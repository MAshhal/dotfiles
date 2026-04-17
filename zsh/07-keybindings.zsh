autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
