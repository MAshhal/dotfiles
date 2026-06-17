# dotfiles

Personal shell environment managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Contents |
|---------|----------|
| `zsh` | `.zshrc` + modular config in `~/.config/zsh/` |
| `ohmyposh` | Custom Oh My Posh prompt theme |
| `fastfetch` | Fastfetch system info config |

## Setup

**Prerequisites**

```bash
# Required
stow        # GNU Stow
zsh         # Shell
oh-my-posh  # Prompt engine
fzf         # Fuzzy finder
zoxide      # Smarter cd
mise        # Runtime version manager

# Optional but recommended
eza         # Better ls (aliases fall back to ls if absent)
bat/batcat  # Syntax-highlighted cat
```

Zinit (the Zsh plugin manager) is bootstrapped automatically on first launch — no manual install needed.

**Install**

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

stow zsh
stow ohmyposh
stow fastfetch
```

Each `stow <package>` command creates symlinks in `$HOME` mirroring the package's directory structure.

## Zsh configuration

The config is split into focused files sourced in order by `.zshrc`:

```
core → zinit → plugins → snippets → prompt →
history → completion → keybindings → aliases → functions → hooks → integrations
```

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
