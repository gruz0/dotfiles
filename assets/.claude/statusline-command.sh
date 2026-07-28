#!/bin/bash
# Status line, two groups separated by a dim divider:
#   LEFT  (location): repo-relative cwd (worktree-aware root) + worktree
#                      badge (only shown inside a linked worktree)
#   RIGHT (status):   model name + context-usage progress bar + 5h/7d
#                      rate-limit bars with reset countdowns

input=$(cat)

# One jq pass for every field the line needs. This script re-runs on each
# render, so a jq per field (seven of them now) is the difference between a
# couple of forks and a visible stall. `// ""` collapses both null and a
# missing key to an empty line; tostring keeps numbers from being emitted as
# bare JSON. One `read` per line - NOT a multi-var `read a b c`, which only
# fills the first var from one line (see prior BUG 1). Vars are pre-cleared
# because command substitution strips ALL trailing newlines, so absent
# trailing fields leave their `read` at EOF with the var untouched.
fields=$(echo "$input" | jq -r '
  [ .workspace.current_dir,
    (.model.display_name // ""),
    (.context_window.used_percentage // ""),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.rate_limits.seven_day.resets_at // "")
  ] | .[] | tostring')
cwd=""; model=""; used_pct=""
rl_5h_pct=""; rl_5h_at=""; rl_7d_pct=""; rl_7d_at=""
{ read -r cwd; read -r model; read -r used_pct
  read -r rl_5h_pct; read -r rl_5h_at
  read -r rl_7d_pct; read -r rl_7d_at; } <<< "$fields"

# Real ESC bytes via ANSI-C quoting. These variables hold actual control
# characters (not the literal text "\033"), so printing them with printf's
# %s (which does NOT interpret backslash escapes) still renders color codes
# correctly. Data (branch/cwd/model) stays on %s too, so it can never be
# misinterpreted as an escape sequence itself.
esc=$'\033'
reset="${esc}[00m"
blue="${esc}[01;34m"
yellow="${esc}[00;33m"
red="${esc}[00;31m"
dim="${esc}[02m"

# Block bar of $1 cells for an integer percentage $2, clamped to the bar's
# ends so a 0% or a >100% reading can't under/overflow it. bash 3.2 (macOS)
# has no string repetition, hence the loops.
make_bar() {
  local width=$1 pct=$2 filled empty i out=""
  filled=$(( pct * width / 100 ))
  [ "$filled" -gt "$width" ] && filled=$width
  [ "$filled" -lt 0 ] && filled=0
  empty=$(( width - filled ))
  i=0; while [ "$i" -lt "$filled" ]; do out="${out}█"; i=$(( i + 1 )); done
  i=0; while [ "$i" -lt "$empty" ];  do out="${out}░"; i=$(( i + 1 )); done
  printf '%s' "$out"
}

# Severity color for a usage percentage: quiet until half spent, yellow
# through the second half, red once there's little headroom left.
pct_color() {
  if   [ "$1" -ge 80 ]; then printf '%s' "$red"
  elif [ "$1" -ge 50 ]; then printf '%s' "$yellow"
  else                       printf '%s' "$dim"
  fi
}

# Compact countdown to a window reset: 3d4h / 2h13m / 13m. A window can roll
# over between renders, so clamp negatives to 0 rather than printing `-1m`.
fmt_eta() {
  local secs=$1 d h m
  [ "$secs" -lt 0 ] && secs=0
  d=$(( secs / 86400 )); h=$(( secs % 86400 / 3600 )); m=$(( secs % 3600 / 60 ))
  if   [ "$d" -gt 0 ]; then printf '%dd%dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then printf '%dh%dm' "$h" "$m"
  else                      printf '%dm' "$m"
  fi
}

# RIGHT group accumulator: right_append <separator> <section>. The separator
# is the glyph that PRECEDES this section, and it is emitted only when an
# earlier section already rendered - each one drops out independently (no
# model name, no context reading yet, either rate-limit window missing), and
# an empty section must not leave a dangling separator behind. An empty
# separator joins with a plain space; `|` fences off each gauge. Sections
# carry no leading space of their own.
right=""
right_append() {
  [ -z "$2" ] && return
  if   [ -z "$right" ]; then right="$2"
  elif [ -z "$1" ];     then right="${right} $2"
  else                       right="${right} ${dim}${1}${reset} $2"
  fi
}

# One rate-limit window: `5h [█░░░░]24% (2h13m)`, colored by severity. Prints
# nothing when the window is absent, which is the normal case for API-key
# users and for Pro/Max sessions before their first API response - the two
# windows are also independently absent, so neither implies the other. The
# countdown is parenthesized rather than separator-joined so it reads as an
# annotation on its own window instead of as another fenced-off section -
# same idiom as the `(#1321)` worktree badge.
# The reset local is `at`, NOT `reset`, which is the ANSI reset sequence.
rl_append() {
  local label=$1 pct_raw=$2 at=$3 pct eta=""
  [ -z "$pct_raw" ] && return
  pct=$(printf '%.0f' "$pct_raw")
  [ -n "$at" ] && eta=" ($(fmt_eta $(( at - now ))))"
  right_append "|" "$(pct_color "$pct")${label} [$(make_bar 5 "$pct")]${pct}%${eta}${reset}"
}

# One rev-parse for everything: worktree root and both git-dir paths (to
# detect a linked worktree - they differ from the main working tree's).
# The worktree badge uses the worktree DIRECTORY basename (this user's
# worktrees live at .claude/worktrees/<number>, e.g. `1296`), prefixed with
# `#` so it reads as an issue number - not the branch name, which would be
# redundant (branch `worktree-1296` + badge would read `#worktree-1296`).
# --path-format=absolute avoids relative/bare `.git` values. Silent/empty
# when cwd isn't a repo. One `read` per line - NOT a multi-var `read a b c`,
# which only fills the first var from one line (see prior BUG 1), and not
# mapfile, which macOS's bash 3.2 lacks.
git_info=$(git -c core.fsmonitor=false --no-optional-locks -C "$cwd" \
  rev-parse --path-format=absolute --show-toplevel --git-dir --git-common-dir 2>/dev/null)
worktree=""
if [ -n "$git_info" ]; then
  { read -r toplevel; read -r git_dir; read -r git_common_dir; } <<< "$git_info"
  main_root="${git_common_dir%/.git}"
  # A linked worktree has its own git dir; the main working tree does not.
  [ "$git_dir" != "$git_common_dir" ] && worktree="#${toplevel##*/}"
  rel="${cwd#"$toplevel"}"; rel="${rel#/}"
  path_part="${main_root##*/}"
  [ -n "$rel" ] && path_part="$path_part/$rel"
else
  # Not a git repo: absolute path with $HOME collapsed to ~.
  # \~ is escaped so bash does NOT tilde-expand the replacement text back
  # into $HOME (an unescaped ~ here round-trips to the literal path).
  path_part="${cwd/#$HOME/\~}"
fi

# Worktree badge: shown only when cwd is inside a LINKED worktree, hidden
# entirely in the main repo checkout.
worktree_part=""
if [ -n "$worktree" ] && [ "$worktree" != "null" ]; then
  worktree_part=" ${yellow}(${worktree})${reset}"
fi

# display_name appends a parenthetical for model variants ("Opus 5 (1M
# context)"); drop it. The suffix costs a dozen columns to say something the
# bar beside it already accounts for - used_percentage is a fraction of
# whichever window is actually in play. %% strips from the FIRST " (" so a
# name with more than one parenthetical loses all of them.
model="${model%% (*}"
[ -n "$model" ] && right_append "" "${dim}${model}${reset}"

# Context bar, same 5-cell width and tight `]NN%` spacing as the rate-limit
# bars so all three read as one row of gauges.
if [ -n "$used_pct" ]; then
  pct_int=$(printf '%.0f' "$used_pct")
  right_append "" "${dim}[$(make_bar 5 "$pct_int")]${pct_int}%${reset}"
fi

# Rate-limit sections: mini bars for the rolling 5-hour and 7-day windows,
# each with a countdown to its reset. `date` is called once, and only when a
# window is actually present, so non-subscriber sessions pay nothing for it.
if [ -n "$rl_5h_pct" ] || [ -n "$rl_7d_pct" ]; then
  now=$(date +%s)
  rl_append "5h" "$rl_5h_pct" "$rl_5h_at"
  rl_append "7d" "$rl_7d_pct" "$rl_7d_at"
fi

# Two-group layout: LEFT (path + worktree badge) | divider | RIGHT (model +
# bars). True right-alignment isn't available to a piped statusline process
# (/dev/tty, $COLUMNS, and `tput cols` are all unusable here), so instead
# the left group is padded to a minimum VISIBLE width so the divider lines
# up across renders when the location text is short. Width is computed from
# the PLAIN text (no ANSI bytes), matching what worktree_part would render.
# Tune the divider column here: raise it for steadier alignment across
# longer paths, lower it for a tighter line. Anything wider just gets its
# padding clamped to zero and pushes the divider right for that render.
left_min_width=18
plain_left="$path_part"
[ -n "$worktree" ] && plain_left="$plain_left (${worktree})"
pad=$(( left_min_width - ${#plain_left} ))
[ "$pad" -lt 0 ] && pad=0
printf -v spacer '%*s' "$pad" ''

printf '%s%s%s%s%s %s│%s %s' \
  "$blue" "$path_part" "$reset" "$worktree_part" "$spacer" "$dim" "$reset" "$right"
