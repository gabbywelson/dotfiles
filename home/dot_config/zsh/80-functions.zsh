# Small helper functions.

# mkcd DIR: make a directory and cd into it.
mkcd() { mkdir -p -- "$1" && cd -- "$1" }

# proj: fuzzy-pick a project under ~/code (previewing its files) and cd there.
proj() {
  local dir
  dir=$(fd --type d --max-depth 2 . ~/code 2>/dev/null |
    fzf --preview='eza --tree --level=2 --icons=always --color=always {}' --prompt='project ❯ ') &&
    cd -- "$dir"
}

# y [DIR]: browse files in yazi; quitting with `q` leaves you in the last dir.
y() {
  local tmp cwd
  tmp=$(mktemp -t yazi-cwd.XXXXXX)
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [[ -n $cwd && $cwd != $PWD ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# rgf [QUERY]: live ripgrep with a bat preview; Enter opens the match in $EDITOR.
rgf() {
  local rg='rg --column --line-number --no-heading --color=always --smart-case --'
  local hit file line
  hit=$(fzf --ansi --disabled --query="$*" --delimiter=: --prompt='rg ❯ ' \
      --bind="start,change:reload:sleep 0.1; [ -n {q} ] && $rg {q} || true" \
      --preview='bat --color=always --style=numbers --highlight-line={2} {1}' \
      --preview-window='right,60%,+{2}+3/3') || return
  file=${hit%%:*} line=${${hit#*:}%%:*}
  case $EDITOR in
    cursor*|code*) ${=EDITOR} --goto "$file:$line" ;;
    *) ${=EDITOR} +$line -- "$file" ;;
  esac
}

# lazygit, themed to match the terminal right now (Catppuccin Latte or Mocha).
lazygit() {
  local flavor=$(catppuccin-flavor) dir=~/.config/lazygit
  local config=$dir/config.yml
  [[ -r $dir/themes/$flavor.yml ]] && config+=",$dir/themes/$flavor.yml"
  LG_CONFIG_FILE=$config DELTA_FEATURES=catppuccin-$flavor command lazygit "$@"
}
alias lg='lazygit'

# dot: the dotfiles helper (~/.local/bin/dot). `dot cd` jumps to the repo.
dot() {
  if [[ $1 == cd ]]; then
    cd -- "${$(chezmoi source-path):h}"
  else
    command dot "$@"
  fi
}

# Docker Compose shortcuts (pluto/charon run their services from ~/stacks).
if [[ $OSTYPE == linux* ]]; then
  dcu() { docker compose up -d "$@" }
  dcd() { docker compose down "$@" }
  dcl() { docker compose logs -f --tail=100 "$@" }
  dcp() { docker compose ps "$@" }
fi
