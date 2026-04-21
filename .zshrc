# Uncomment to profile startup
# zmodload zsh/zprof

ZSH_CONF_DIR="${HOME}/dotfiles/zsh"

for file in "${ZSH_CONF_DIR}"/[0-9][0-9]-*.zsh; do
  [[ -r "$file" ]] && source "$file"
done

# zprof
