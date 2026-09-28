# --- Zinit ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# If Zinit directory doesn't exist, download it
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# --- Plugins ---
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

# --- Oh My Zsh snippets ---
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::alias-finder

# --- Completion ---
autoload -Uz compinit

# Only rebuild cache if dump is older than 24h
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' group-name ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format ' no matches for: %d'
zstyle ':fzf-tab:complete:cd:*'          fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*'  fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'if [[ -d $realpath ]]; then ls --color $realpath; elif [[ -f $realpath ]]; then bat --color=always --style=plain $realpath 2>/dev/null || cat $realpath; fi'
