autoload -Uz add-zsh-hook

# Auto-activate/deactivate Python virtualenv on directory change
function hook_auto_venv() {

  # Deactivate if we've left the project that owns the active venv
  if [[ -n "$VIRTUAL_ENV" ]]; then
    local venv_root="${VIRTUAL_ENV:h}"   # parent dir of the .venv folder
    if [[ "$PWD" != "$venv_root" && "$PWD" != "$venv_root"/* ]]; then
      deactivate 2>/dev/null
    fi
  fi

  # Activate the first venv found in the current directory
  if [[ -z "$VIRTUAL_ENV" ]]; then
    local venv_dir
    for venv_dir in .venv venv env; do
      if [[ -f "$PWD/$venv_dir/bin/activate" ]]; then
        source "$PWD/$venv_dir/bin/activate"
        break
      fi
    done
  fi
}
add-zsh-hook chpwd hook_auto_venv

# Run once at shell startup to handle launching inside a project directory
hook_auto_venv
