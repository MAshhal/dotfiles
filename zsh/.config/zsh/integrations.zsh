eval "$(fzf --zsh)"

eval "$(/usr/bin/mise activate zsh)"

if [[ -o interactive ]] && command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi
