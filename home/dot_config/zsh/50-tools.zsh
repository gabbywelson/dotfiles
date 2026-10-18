# Shell hooks for the CLI toolbox. Each is skipped when the tool isn't installed,
# so a half-bootstrapped machine still gets a working shell.

# Source a tool's init script from ~/.cache/zsh instead of running the tool on
# every startup. The cache is rebuilt when the binary (resolved through
# symlinks, so upgrades count) or the arguments change. `dot update` clears it.
_cached_eval() {
  local bin=${commands[$1]}
  [[ -n $bin ]] || return 0
  local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init-$1.zsh stamp="# ${bin:A} $*" first
  [[ -r $cache ]] && IFS= read -r first <$cache
  if [[ $first != "$stamp" ]]; then
    mkdir -p ${cache:h}
    { print -r -- "$stamp"; "$@" } >|$cache 2>/dev/null || { rm -f $cache; return 1 }
  fi
  source $cache
}

# mise: per-project runtimes (Node, Python, ...) from mise.toml / .tool-versions.
# Not cached: its init script captures the current PATH.
(( $+commands[mise] )) && eval "$(mise activate zsh)"

_cached_eval direnv hook zsh   # per-project env vars from .envrc (`direnv allow`)
_cached_eval zoxide init zsh   # `z foo` jumps to your most-used dir matching foo; `zi` picks

# --- fzf: Ctrl-T files, Alt-C dirs, ** <Tab> anywhere --------------------------
# ANSI color names (not hex) so fzf matches Catppuccin Latte or Mocha, whichever
# Ghostty is showing.
_fzf_theme=(
  --color=fg:-1,bg:-1,hl:blue:bold,fg+:-1:bold,bg+:-1,hl+:blue:bold,gutter:-1
  --color=info:bright-black,border:bright-black,separator:bright-black,scrollbar:bright-black
  --color=prompt:magenta,pointer:magenta,marker:green,spinner:magenta,header:cyan
  --pointer=▌ --marker=┃ --scrollbar=│ --separator=─
)
export FZF_DEFAULT_OPTS="--height=50% --layout=reverse --border=rounded --info=inline-right \
  --prompt='❯ ' $_fzf_theme --bind=ctrl-/:toggle-preview"
# fzf-tab (Tab completion, see 40-plugins) gets the same look. It can't reuse
# FZF_DEFAULT_OPTS: it splits the string without honoring the quotes.
zstyle ':fzf-tab:*' fzf-flags $_fzf_theme --bind=ctrl-/:toggle-preview
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers --line-range=:300 {} 2>/dev/null'"
export FZF_ALT_C_OPTS="--preview='eza --tree --level=2 --color=always --icons=always {}'"

# Key bindings need a real terminal (not `zsh -ic` from scripts and agents).
if [[ -t 0 && -t 1 ]]; then
  _cached_eval fzf --zsh
  _cached_eval atuin init zsh --disable-up-arrow   # Ctrl-R: full-screen history search
fi

# --- Installer-managed extras (each only where installed) -----------------------
[[ -s ~/.bun/_bun ]] && source ~/.bun/_bun
[[ -r ~/.railway/env ]] && source ~/.railway/env
_cached_eval entire completion zsh
