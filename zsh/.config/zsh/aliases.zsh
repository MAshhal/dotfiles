# --- Navigation ---
if command -v eza &>/dev/null; then
  alias ls='eza --color=always --group-directories-first'
  alias ll='eza -la --color=always --group-directories-first --git'
  alias la='eza -a --color=always --group-directories-first'
  alias lt='eza --tree --color=always --group-directories-first --icons -L 2'
else
  alias ls='ls --color'
  alias ll='ls -lah --color'
  alias la='ls -ah --color'
fi

# --- Tools ---
alias bat='batcat'
alias c='clear'
alias clip='xclip -selection clipboard'
alias dud='du -d 1 -h'

# --- Config shortcuts ---
alias zshrc="${EDITOR} ~/.zshrc"
alias prompt_conf="${EDITOR} ~/.config/ohmyposh/${PROMPT_CONFIG_FILENAME}"

# --- Suffix aliases ---
alias -s json=jless
alias -s md=bat
alias -s yaml=bat
alias -s txt=bat
alias -s log=bat
alias -s kt='$EDITOR'
alias -s kts='$EDITOR'
alias -s php='$EDITOR'
alias -s py='$EDITOR'

# --- Global Aliases ---
alias -g G='| grep --color=auto'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g C='| xclip -selection clipboard'


# --- Diagnostics ---
alias perf='time zsh -i -c exit'

alias colorscheme='echo -e "COLOR          NORMAL      INTENSE"; \
echo -e "Black          \e[30m[Color 0]\e[0m    \e[90m[Color 8]\e[0m"; \
echo -e "Red            \e[31m[Color 1]\e[0m    \e[91m[Color 9]\e[0m"; \
echo -e "Green          \e[32m[Color 2]\e[0m    \e[92m[Color 10]\e[0m"; \
echo -e "Yellow         \e[33m[Color 3]\e[0m    \e[93m[Color 11]\e[0m"; \
echo -e "Blue           \e[34m[Color 4]\e[0m    \e[94m[Color 12]\e[0m"; \
echo -e "Magenta        \e[35m[Color 5]\e[0m    \e[95m[Color 13]\e[0m"; \
echo -e "Cyan           \e[36m[Color 6]\e[0m    \e[96m[Color 14]\e[0m"; \
echo -e "White          \e[37m[Color 7]\e[0m    \e[97m[Color 15]\e[0m"'
