if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --group-directories-first --git'
  alias la='eza -la --group-directories-first --git'
  alias lt='eza --tree --level=2'
fi
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v batcat >/dev/null 2>&1 && alias cat='batcat --paging=never'

alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git switch'
alias gcb='git switch -c'
alias lg='lazygit'
alias code='cd ~/code'
alias stacks='cd ~/stacks'

mkcd() { mkdir -p "$1" && cd "$1"; }
dcu() { docker compose up -d "$@"; }
dcd() { docker compose down "$@"; }
dcl() { docker compose logs -f --tail=100 "$@"; }
dcp() { docker compose ps "$@"; }
