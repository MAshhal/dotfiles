autoload -Uz add-zsh-hook

# Auto-activate/deactivate Python virtualenv on directory change
function auto_venv() {
  # Resolve current directory to an absolute canonical path
  local pwd_real="$(realpath "$PWD")"

  # --- Deactivate if we've left the active venv's project ---
  if [[ -n "$VIRTUAL_ENV" ]]; then
    local venv_root="$(realpath "${VIRTUAL_ENV:h}")"

    # Check if we're still inside the project directory
    if [[ "$pwd_real" != "$venv_root" && "$pwd_real" != "$venv_root"/* ]]; then
      deactivate 2>/dev/null
    fi
  fi

  # --- Activate if not already in a venv ---
  if [[ -z "$VIRTUAL_ENV" ]]; then
    local dir="$pwd_real"

    while [[ "$dir" != "/" ]]; do
      for venv_dir in .venv venv env; do
        if [[ -f "$dir/$venv_dir/bin/activate" ]]; then
          source "$dir/$venv_dir/bin/activate"
          return
        fi
      done
      dir="$(dirname "$dir")"
    done
  fi
}
add-zsh-hook chpwd auto_venv

# Run once at shell startup to handle launching inside a project directory
auto_venv
