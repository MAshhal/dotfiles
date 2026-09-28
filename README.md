# dotfiles

Personal shell environment managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Contents |
|---------|----------|
| `zsh` | `.zshrc` + config modules in `~/.config/zsh/` |
| `ohmyposh` | Custom Oh My Posh prompt theme |
| `fastfetch` | Fastfetch system info config |

## Setup

**Tools**

```bash
stow        # GNU Stow
zsh         # Shell
oh-my-posh  # Prompt engine
fzf         # Fuzzy finder
zoxide      # Smarter cd
mise        # Runtime version manager
fastfetch   # System info on shell start
eza         # Better ls
bat/batcat  # Syntax-highlighted cat
```

`install.sh` installs any of these that are missing (see below).

Zinit (the Zsh plugin manager) is bootstrapped automatically on first launch — no manual install needed.

**Install**

```bash
git clone https://github.com/MAshhal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` installs any missing tools from the list above, then stows every package into `$HOME`. It is safe to re-run.

Tools come from the system package manager (pacman, apt, dnf, zypper or Homebrew, using `sudo` when needed). When the distro doesn't ship one, the script falls back to the upstream installer: oh-my-posh, mise and zoxide go into `~/.local/bin`, and fastfetch is installed from its release `.deb` on Debian/Ubuntu. Anything it still can't install is listed at the end.

If a real file already sits where a symlink should go (for example an existing `~/.zshrc`), the script lists it and stops without changing anything.

| Option | Effect |
|--------|--------|
| `-n`, `--dry-run` | Show what would happen without touching `$HOME` |
| `-b`, `--backup` | Move conflicting files to `~/.dotfiles-backup/<timestamp>/`, then stow |
| `--no-install` | Only report missing tools, don't install them |
| `-h`, `--help` | Show usage |

To stow packages by hand instead, run `stow zsh`, `stow ohmyposh` and `stow fastfetch` from the repo root. Each `stow <package>` command creates symlinks in `$HOME` mirroring the package's directory structure.

## Zsh configuration

`.zshrc` holds shell options, history and keybindings, then sources the rest of `~/.config/zsh/` in order:

| File | Contents |
|------|----------|
| `plugins.zsh` | Zinit bootstrap, plugins, Oh My Zsh snippets, completion setup |
| `tools.zsh` | oh-my-posh, fzf, mise and zoxide, each skipped if not installed |
| `aliases.zsh` | Aliases |
| `functions.zsh` | Shell functions and the auto-venv hook |
| `local.zsh` | Optional, git-ignored: machine-specific PATH entries or overrides such as `EDITOR` |

Notable behaviours:

- **Auto-venv** — Python virtualenvs (`.venv/`, `venv/`, `env/`) are activated/deactivated automatically on `cd` via a `chpwd` hook
- **fzf-tab** — tab completion is replaced with an fzf picker with file/directory previews via `bat`
- **History substring search** — `↑`/`↓` and `^p`/`^n` filter history by what's already typed
- **zoxide** — replaces `cd` with a frecency-based jump command
- **Suffix aliases** — opening a file by extension launches the right tool (e.g. `file.json` opens in `jless`)

## Prompt

Custom Oh My Posh theme (`ohmyposh/.config/ohmyposh/mystic.omp.json`).

Left side: full path → git status (color-coded: blue=clean, yellow=dirty, green=ahead, red=diverged)  
Right side: execution time (shown when > 100 ms) · root indicator · RAM usage  
Transient prompt collapses previous lines to `folder ➜` to reduce noise.

Edit the theme with `prompt_conf` (alias opens it in `$EDITOR`), then reload with `exec zsh`.

## Useful aliases

| Alias | Expands to |
|-------|-----------|
| `ll` | `eza -la --git` (or `ls -lah`) |
| `lt` | `eza --tree -L 2` |
| `bat` | `batcat` |
| `c` | `clear` |
| `clip` | `xclip -selection clipboard` |
| `zshrc` | Open `.zshrc` in `$EDITOR` |
| `prompt_conf` | Open OMP theme in `$EDITOR` |
| `zshtime` | Time a fresh shell startup |
| `G` / `L` / `H` / `T` / `C` | Global: `\| grep` / `\| less` / `\| head` / `\| tail` / `\| xclip` |

## Managing symlinks

```bash
stow -n zsh      # Dry-run (preview without linking)
stow zsh         # Deploy
stow -D zsh      # Remove symlinks
stow -R zsh      # Re-stow (remove then re-link)
```
