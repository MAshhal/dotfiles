# Make a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# Go up N directories (default: 1)
up() {
  local d=""
  for i in $(seq 1 ${1:-1}); do d="../$d"; done
  cd "$d"
}

# Extract any common archive format
extract() {
  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a file" >&2
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1"   ;;
    *.tar.gz)  tar xzf "$1"   ;;
    *.tar.xz)  tar xJf "$1"   ;;
    *.tar.zst) tar --use-compress-program=unzstd -xf "$1" ;;
    *.tar)     tar xf  "$1"   ;;
    *.bz2)     bunzip2 "$1"   ;;
    *.gz)      gunzip  "$1"   ;;
    *.zip)     unzip   "$1"   ;;
    *.7z)      7z x    "$1"   ;;
    *.rar)     unrar x "$1"   ;;
    *) echo "extract: unknown format '${1##*.}'" >&2; return 1 ;;
  esac
}

# --- Hooks ---
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
