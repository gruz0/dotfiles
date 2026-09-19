# -*- sh -*- vim:set ft=sh ai et sw=4 sts=4:
time="%{$fg[yellow]%}%T"
PROMPT='[${time}] %{$fg_bold[blue]%}%2~ $(git_prompt_info)%{$reset_color%}%(?..%{$fg[red]%})%(!.#.$)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[red]%}›%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{208}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=""
