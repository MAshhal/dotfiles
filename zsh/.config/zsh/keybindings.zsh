autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# ^p / ^n and arrow keys are bound to history-substring-search in plugins.zsh
# once that plugin loads via turbo mode
