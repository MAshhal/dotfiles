# Profile startup with `zshtime` (sets ZSH_DEBUGRC)
[[ -n $ZSH_DEBUGRC ]] && zmodload zsh/zprof

# --- Options ---
setopt EXTENDED_GLOB          # Enables advanced pattern matching (globbing).
setopt AUTO_CD                # Lets you change directories just by typing the folder name.
setopt CDABLE_VARS            # Allows you to cd into directories stored in variables.
setopt CORRECT                # Automatically suggests corrections for mistyped commands.
setopt GLOB_DOTS              # Includes hidden files (dotfiles) in glob matches.
setopt PUSHD_IGNORE_DUPS      # Prevents duplicate entries in the directory stack when using pushd.
setopt PUSHD_SILENT           # Suppresses output when using pushd / popd.
setopt INTERACTIVE_COMMENTS   # Allows comments in the interactive shell.

export EDITOR="kate --block"
path+=("$HOME/.local/bin")

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE

# --- Keybindings ---
# ↑/↓ and ^p/^n are bound to history-substring-search in plugins.zsh
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# --- Modules ---
# local.zsh is untracked: machine-specific PATH entries, EDITOR overrides, etc.
ZSH_CONF_DIR="${HOME}/.config/zsh"

for file in plugins tools aliases functions local; do
  [[ -r "${ZSH_CONF_DIR}/${file}.zsh" ]] && source "${ZSH_CONF_DIR}/${file}.zsh"
done

[[ -n $ZSH_DEBUGRC ]] && zprof
