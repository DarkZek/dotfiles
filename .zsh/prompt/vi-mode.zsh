bindkey -v

bindkey -M viins '^[[A' history-beginning-search-backward
bindkey -M viins '^[[B' history-beginning-search-forward
bindkey -M vicmd '^[[A' history-beginning-search-backward
bindkey -M vicmd '^[[B' history-beginning-search-forward

INSERT_MODE="${GREEN}❯"
CMD_MODE="${RED}❯"
VIM_MODE=$INSERT_MODE

zle-keymap-select() {
  VIM_MODE="${${KEYMAP/vicmd/${CMD_MODE}}/(main|viins)/${INSERT_MODE}}"

  if [[ ${KEYMAP} == vicmd ]] ||
  [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'

  elif [[ ${KEYMAP} == main ]] ||
  [[ ${KEYMAP} == viins ]] ||
  [[ ${KEYMAP} = '' ]] ||
  [[ $1 = 'beam' ]]; then
    echo -ne '\e[3 q'
  fi

  zle reset-prompt
}

zle-line-finish() {
  VIM_MODE=$INSERT_MODE
}

zle -N zle-keymap-select
zle -N zle-line-finish

export KEYTIMEOUT=1
