# Aliases. `alias` lists them all; `which ll` explains one.
# Tool-backed aliases only exist when the tool is installed, so plain commands
# keep working on a fresh machine.

# --- Shell -----------------------------------------------------------------------
alias reload='exec zsh'          # restart the shell to pick up config changes
alias c='clear'
alias cl='clear'
alias q='exit'
alias h='history'
alias j='jobs -l'
alias path='print -l $path'      # PATH, one entry per line
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# --- Navigation (also: `z <part of a path>` and `zi`) ----------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias code='cd ~/code'
alias docs='cd ~/Documents'
alias dl='cd ~/Downloads'

# --- Listing (eza) -----------------------------------------------------------------
if (( $+commands[eza] )); then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -la --icons=auto --group-directories-first --git --time-style=relative'
  alias la='eza -a --icons=auto --group-directories-first'
  alias lt='eza --tree --level=2 --icons=auto'
  alias lta='eza --tree --level=2 --icons=auto -a --git-ignore'
  alias tree='eza --tree --icons=auto'
fi
(( $+commands[tree] )) && alias t='command tree --gitignore --prune'   # real tree, minus ignored files

# --- Viewing (bat, glow) -----------------------------------------------------------
if (( $+commands[bat] )); then
  alias cat='bat --paging=never'   # plain output when piped, like cat
  alias catp='bat'                 # with a pager
  alias less='bat'
fi

# --- Safety nets ------------------------------------------------------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# --- Git (also: `lg` for lazygit, `gdt` for structural diffs) --------------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool --tool=difftastic'   # diff by syntax tree, not by line
alias gco='git switch'
alias gcb='git switch -c'
alias gb='git branch'
alias gba='git branch -a'
alias glog='git log --oneline --graph --decorate -15'
alias gloga='git log --oneline --graph --decorate --all'
alias gst='git stash'
alias gstp='git stash pop'

# --- JavaScript ----------------------------------------------------------------------
alias ni='npm install'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias pr='pnpm run'
alias prd='pnpm run dev'
alias prb='pnpm run build'
alias prt='pnpm run test'
alias px='pnpm dlx'

# --- Dotfiles (see also: `dot help`) ---------------------------------------------
alias cz='chezmoi'
alias cze='chezmoi edit'
alias cza='chezmoi apply'
alias czd='chezmoi diff'
alias czu='chezmoi update'
alias zshrc='chezmoi edit --apply ~/.zshrc'
alias aliases='chezmoi edit --apply ~/.config/zsh/70-aliases.zsh'
alias gitconfig='chezmoi edit --apply ~/.gitconfig'

# --- Misc ------------------------------------------------------------------------------
(( $+commands[fastfetch] )) && alias ff='fastfetch'
alias publicip='curl -s ifconfig.me'

# --- macOS ------------------------------------------------------------------------------
if [[ $OSTYPE == darwin* ]]; then
  alias ip='curl -s ifconfig.me'            # public IP (Linux keeps the real `ip`)
  alias localip='ipconfig getifaddr en0'
  alias o='open'
  alias oo='open .'                         # current dir in Finder
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
fi

# --- Linux hosts (pluto, charon) -------------------------------------------------------
if [[ $OSTYPE == linux* ]]; then
  alias localip="hostname -I | awk '{print \$1}'"
  alias stacks='cd ~/stacks'
  alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
fi
