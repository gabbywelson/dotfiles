command -v mise >/dev/null 2>&1 && eval "$(mise activate bash)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"

if [ -t 0 ] && [ -t 1 ] && command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
  export FZF_DEFAULT_OPTS='--height=45% --layout=reverse --border'
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
fi

[ -t 0 ] && [ -t 1 ] && command -v atuin >/dev/null 2>&1 && eval "$(atuin init bash --disable-up-arrow)"
[ "${TERM:-dumb}" != dumb ] && command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
