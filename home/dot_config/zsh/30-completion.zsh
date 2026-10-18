# Completion. fzf-tab (loaded next, in 40-plugins) turns the menu into a fuzzy picker.

# Extra completion definitions: Homebrew's, installer-provided ones, and those
# `dot update` generates for mise-installed tools on Linux.
fpath=(
  ~/.local/share/zsh/site-functions(N/)
  ~/.grok/completions/zsh(N/)
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh/site-functions}(N/)
  $fpath
)

# Rebuild the completion cache at most once a day; otherwise skip the slow audit.
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) || ! -e ~/.zcompdump ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'   # case-insensitive, then fuzzy-ish
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no                                   # fzf-tab owns the menu
zstyle ':completion:*:descriptions' format '[%d]'                # fzf-tab group headers
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-~/.cache}/zsh/compcache
zstyle ':completion:*:git-checkout:*' sort false                 # keep git's own branch order
