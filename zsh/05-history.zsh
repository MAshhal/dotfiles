HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory sharehistory
setopt hist_ignore_all_dups hist_save_no_dups hist_find_no_dups hist_ignore_space hist_ignore_dups
