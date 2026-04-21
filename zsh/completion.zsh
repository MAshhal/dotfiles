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
