#!/usr/bin/env bash

_pl888_ls_color_alias=""

if command ls --color=auto -d . >/dev/null 2>&1; then
    _pl888_ls_color_alias="ls --color=auto"
elif command ls -G -d . >/dev/null 2>&1; then
    _pl888_ls_color_alias="ls -G"
fi

if [[ -n "${_pl888_ls_color_alias}" ]]; then
    alias ls="${_pl888_ls_color_alias}"
fi

alias l='ls -CF'
alias la='ls -la'
alias ll='ls -alF'
alias lt='ls -lt'
alias lta='ls -lta'
alias lat='lta'
alias ltd='ls -ltd'
alias ldt='ltd'
alias lth='ls -lt | head'
alias lht='lth'
alias ltt='ls -lt | tail'

unset _pl888_ls_color_alias
