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
