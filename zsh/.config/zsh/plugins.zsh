# Loaded synchronously — needed before compinit
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Turbo mode: deferred until after prompt renders
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Bind up/down arrows + ^p/^n once the plugin is available
zinit ice wait lucid atload"
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^p'   history-substring-search-up
  bindkey '^n'   history-substring-search-down
"
zinit light zsh-users/zsh-history-substring-search

# fast-syntax-highlighting: drop-in replacement for zsh-syntax-highlighting, noticeably faster
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting