# Plugins via antidote. The static bundle is only rebuilt when plugins.txt
# changes, so antidote itself isn't loaded on a normal startup.

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

if [[ -r ~/.antidote/antidote.zsh ]]; then
  fpath=(~/.antidote/functions $fpath)
  autoload -Uz antidote             # `antidote update`, `antidote list`, ...
  () {
    local txt=~/.config/zsh/plugins.txt bundle=${XDG_CACHE_HOME:-~/.cache}/zsh/plugins.zsh
    if [[ ! $bundle -nt $txt ]]; then
      mkdir -p ${bundle:h}
      antidote bundle <$txt >|$bundle
    fi
    source $bundle
  }
fi

# fzf-tab: < and > switch completion groups; colors are set with fzf's in 50-tools.
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:(cd|z|zi):*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
zstyle ':fzf-tab:complete:(cat|bat|less|nvim|vim):*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || eza -1 --color=always --icons=always $realpath'
