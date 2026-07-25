#!/bin/bash
# Status line, two groups separated by a dim divider:
#   LEFT  (location): repo-relative cwd (worktree-aware root) + worktree
#                      badge (only shown inside a linked worktree)
#   RIGHT (status):   model name + context-usage progress bar

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Real ESC bytes via ANSI-C quoting. These variables hold actual control
# characters (not the literal text "\033"), so printing them with printf's
# %s (which does NOT interpret backslash escapes) still renders color codes
# correctly. Data (branch/cwd/model) stays on %s too, so it can never be
# misinterpreted as an escape sequence itself.
esc=$'\033'
reset="${esc}[00m"
blue="${esc}[01;34m"
yellow="${esc}[00;33m"
dim="${esc}[02m"

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

# No leading space here: the divider (below) already supplies the space
# that separates it from whatever comes next, so a leading space here would
# double up right after the divider.
model_part=""
if [ -n "$model" ] && [ "$model" != "null" ]; then
  model_part="${dim}${model}${reset}"
fi

bar_part=""
if [ -n "$used_pct" ]; then
  pct_int=$(printf '%.0f' "$used_pct")
  filled=$(( pct_int / 10 ))
  [ "$filled" -gt 10 ] && filled=10
  [ "$filled" -lt 0 ] && filled=0
  empty=$(( 10 - filled ))
  bar_fill=""
  bar_empty=""
  i=0
  while [ "$i" -lt "$filled" ]; do bar_fill="${bar_fill}█"; i=$(( i + 1 )); done
  i=0
  while [ "$i" -lt "$empty" ]; do bar_empty="${bar_empty}░"; i=$(( i + 1 )); done
  bar_part=" ${dim}[${bar_fill}${bar_empty}] ${pct_int}%${reset}"
fi

# Two-group layout: LEFT (path + worktree badge) | divider | RIGHT (model +
# bar). True right-alignment isn't available to a piped statusline process
# (/dev/tty, $COLUMNS, and `tput cols` are all unusable here), so instead
# the left group is padded to a minimum VISIBLE width so the divider lines
# up across renders when the location text is short. Width is computed from
# the PLAIN text (no ANSI bytes), matching what worktree_part would render.
plain_left="$path_part"
[ -n "$worktree" ] && plain_left="$plain_left (${worktree})"
pad=$(( 28 - ${#plain_left} ))
[ "$pad" -lt 0 ] && pad=0
printf -v spacer '%*s' "$pad" ''

printf '%s%s%s%s%s %s│%s %s%s' \
  "$blue" "$path_part" "$reset" "$worktree_part" "$spacer" "$dim" "$reset" "$model_part" "$bar_part"
