#!/usr/bin/env bash
# Bootstrap these dotfiles: install the tools they rely on, then stow every package into $HOME.
#
# Usage: ./install.sh [--dry-run] [--backup] [--no-install] [--help]

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${HOME}"
DRY_RUN=0
BACKUP=0
INSTALL=1

# "a|b" means any one of several command names satisfies the tool.
TOOLS=(stow zsh oh-my-posh fzf zoxide mise fastfetch eza "bat|batcat")

if [[ -t 1 ]]; then
    RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BOLD=$'\e[1m' RESET=$'\e[0m'
else
    RED='' GREEN='' YELLOW='' BOLD='' RESET=''
fi

info() { printf '%s\n' "$*"; }
ok()   { printf '  %s✓%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '  %s!%s %s\n' "$YELLOW" "$RESET" "$*"; }
fail() { printf '  %s✗%s %s\n' "$RED" "$RESET" "$*"; }
die()  { printf '%serror:%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

usage() {
    cat <<USAGE
Usage: ./install.sh [options]

Installs any missing tools, then stows every package in this repo into \$HOME.

Options:
  -n, --dry-run     Show what would happen without changing anything
  -b, --backup      Move conflicting files to ~/.dotfiles-backup/<timestamp>/
                    instead of aborting
      --no-install  Only report missing tools, don't install them
  -h, --help        Show this help
USAGE
}

while (($#)); do
    case "$1" in
        -n|--dry-run)  DRY_RUN=1 ;;
        -b|--backup)   BACKUP=1 ;;
        --no-install)  INSTALL=0 ;;
        -h|--help)     usage; exit 0 ;;
        *)             usage >&2; die "unknown option: $1" ;;
    esac
    shift
done

# Official installers drop binaries here, so make them visible to this run.
export PATH="$HOME/.local/bin:$PATH"

# --- Tools -----------------------------------------------------------------

have() {
    local cmd
    IFS='|' read -ra cmds <<<"$1"
    for cmd in "${cmds[@]}"; do
        command -v "$cmd" >/dev/null 2>&1 && return 0
    done
    return 1
}

detect_pm() {
    local pm
    for pm in pacman apt-get dnf zypper brew; do
        command -v "$pm" >/dev/null 2>&1 && { echo "$pm"; return; }
    done
}

# Package name for a tool under a package manager; empty when the distro
# doesn't ship it and the official installer should be used instead.
pkg_name() {
    local pm="$1" tool="$2"
    case "$tool" in
        oh-my-posh) [[ "$pm" == brew ]] && echo oh-my-posh ;;
        mise)       [[ "$pm" == brew || "$pm" == pacman ]] && echo mise ;;
        "bat|batcat") echo bat ;;
        *)          echo "$tool" ;;
    esac
    return 0
}

SUDO=()
if ((EUID != 0)) && command -v sudo >/dev/null 2>&1; then
    SUDO=(sudo)
fi

apt_updated=0
pm_install() {
    local pm="$1" pkg="$2"
    case "$pm" in
        pacman)  "${SUDO[@]}" pacman -S --needed --noconfirm "$pkg" ;;
        apt-get)
            if ((!apt_updated)); then "${SUDO[@]}" apt-get update -qq; apt_updated=1; fi
            "${SUDO[@]}" apt-get install -y -qq "$pkg" ;;
        dnf)     "${SUDO[@]}" dnf install -y -q "$pkg" ;;
        zypper)  "${SUDO[@]}" zypper --non-interactive install "$pkg" ;;
        brew)    brew install "$pkg" ;;
    esac
}

# Upstream installers, used when the package manager doesn't have the tool.
# Each installs into ~/.local/bin without needing root.
official_install() {
    have curl || { warn "curl is needed to install $1"; return 1; }
    mkdir -p "$HOME/.local/bin"
    case "$1" in
        oh-my-posh) curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin" ;;
        mise)       curl -fsSL https://mise.run | sh ;;
        zoxide)     curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh ;;
        fastfetch)  fastfetch_deb ;;
        *)          return 1 ;;
    esac
}

# Older Debian/Ubuntu releases don't package fastfetch; use the upstream .deb.
fastfetch_deb() {
    command -v dpkg >/dev/null 2>&1 || return 1
    local arch deb
    case "$(uname -m)" in
        x86_64)  arch=amd64 ;;
        aarch64) arch=aarch64 ;;
        *)       return 1 ;;
    esac
    deb="$(mktemp --suffix=.deb)"
    curl -fsSL -o "$deb" "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-$arch.deb" &&
        "${SUDO[@]}" dpkg -i "$deb"
    local rc=$?
    rm -f "$deb"
    return "$rc"
}

has_official() {
    case "$1" in
        oh-my-posh|mise|zoxide) return 0 ;;
        fastfetch) command -v dpkg >/dev/null 2>&1 ;;
        *) return 1 ;;
    esac
}

install_tool() {
    local tool="$1" pm="$2" pkg
    pkg="$(pkg_name "$pm" "$tool")"
    if [[ -n "$pm" && -n "$pkg" ]]; then
        pm_install "$pm" "$pkg" >/dev/null 2>&1 || true
        have "$tool" && return 0
    fi
    if has_official "$tool"; then
        official_install "$tool" >/dev/null 2>&1 || true
    fi
    have "$tool"
}

info "${BOLD}Checking tools${RESET}"
missing=()
for tool in "${TOOLS[@]}"; do
    if have "$tool"; then ok "${tool//|//}"; else fail "${tool//|//}"; missing+=("$tool"); fi
done

if ((${#missing[@]})) && ((INSTALL)); then
    pm="$(detect_pm)"
    info ""
    info "${BOLD}Installing missing tools${RESET}${pm:+ (via $pm)}"
    # Ask for the password once up front; installer output is hidden below.
    if ((!DRY_RUN)) && ((${#SUDO[@]})) && [[ -n "$pm" && "$pm" != brew ]]; then
        sudo -v || die "sudo is needed to install packages. Re-run with --no-install to skip."
    fi
    still_missing=()
    for tool in "${missing[@]}"; do
        name="${tool//|//}"
        pkg="$(pkg_name "$pm" "$tool")"
        if ((DRY_RUN)); then
            if [[ -n "$pm" && -n "$pkg" ]]; then
                warn "would install $name with $pm"
            elif has_official "$tool"; then
                warn "would install $name with its official installer"
            else
                warn "no install method for $name"
            fi
            continue
        fi
        if install_tool "$tool" "$pm"; then
            ok "$name"
        else
            fail "$name (install it manually)"
            still_missing+=("$tool")
        fi
    done
    ((DRY_RUN)) || missing=("${still_missing[@]+"${still_missing[@]}"}")
fi

if ((${#missing[@]})) && ! ((DRY_RUN)); then
    info ""
    warn "Still missing: ${missing[*]//|//}"
fi

if ! have stow; then
    ((DRY_RUN)) || die "GNU Stow is needed to link the dotfiles. Install it and re-run."
    info ""
    ok "dry run: would stow every package once stow is installed"
    exit 0
fi

# --- Packages --------------------------------------------------------------

packages=()
for dir in "$DOTFILES"/*/; do
    packages+=("$(basename "$dir")")
done
((${#packages[@]})) || die "no packages found in $DOTFILES"

# A target conflicts when something exists there that isn't already our symlink.
conflicts=()
for pkg in "${packages[@]}"; do
    while IFS= read -r -d '' src; do
        rel="${src#"$DOTFILES/$pkg/"}"
        dest="$TARGET/$rel"
        if [[ -e "$dest" || -L "$dest" ]]; then
            [[ "$(realpath -m "$dest")" == "$(realpath -m "$src")" ]] || conflicts+=("$rel")
        fi
    done < <(find "$DOTFILES/$pkg" -type f -print0)
done

info ""
info "${BOLD}Stowing ${packages[*]} into $TARGET${RESET}"

if ((${#conflicts[@]})); then
    if ((BACKUP)); then
        backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
        for rel in "${conflicts[@]}"; do
            if ((DRY_RUN)); then
                warn "would back up $TARGET/$rel to $backup_dir/$rel"
            else
                mkdir -p "$(dirname "$backup_dir/$rel")"
                mv "$TARGET/$rel" "$backup_dir/$rel"
                warn "backed up $TARGET/$rel to $backup_dir/$rel"
            fi
        done
    else
        for rel in "${conflicts[@]}"; do fail "$TARGET/$rel already exists"; done
        die "existing files would be overwritten. Re-run with --backup to move them aside."
    fi
fi

stow_args=(--dir "$DOTFILES" --target "$TARGET" --restow)
if ((DRY_RUN)); then
    # Conflicts were only reported above, so stow's own dry run would still see them.
    if ((${#conflicts[@]})); then
        ok "dry run: would stow ${packages[*]} after backing up"
    else
        stow "${stow_args[@]}" --no --verbose "${packages[@]}"
        ok "dry run: no changes made"
    fi
    exit 0
fi

stow "${stow_args[@]}" "${packages[@]}"
for pkg in "${packages[@]}"; do ok "$pkg"; done

info ""
info "Done. Start a new shell with ${BOLD}exec zsh${RESET}."
if ((${#missing[@]})); then
    warn "Some tools are still missing: ${missing[*]//|//}"
fi
