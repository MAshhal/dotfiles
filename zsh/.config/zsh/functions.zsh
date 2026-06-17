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
