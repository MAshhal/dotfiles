# Uncomment to profile startup
# zmodload zsh/zprof

ZSH_CONF_DIR="${HOME}/.config/zsh"

for file in \
  core zinit plugins snippets prompt \
  history completion keybindings aliases functions hooks integrations
do
  [[ -r "${ZSH_CONF_DIR}/${file}.zsh" ]] && source "${ZSH_CONF_DIR}/${file}.zsh"
done

# zprof
