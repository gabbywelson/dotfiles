# History, shell options and key bindings.

# --- History -------------------------------------------------------------------
# atuin (Ctrl-R) keeps the searchable, synced history; this file backs Up-arrow.
HISTFILE=~/.zsh_history HISTSIZE=100000 SAVEHIST=100000
setopt SHARE_HISTORY          # every shell sees new history immediately
setopt HIST_IGNORE_ALL_DUPS   # keep only the newest copy of a command
setopt HIST_IGNORE_SPACE      # " secret-command" stays out of history
setopt HIST_REDUCE_BLANKS HIST_VERIFY   # `!!` expands for review instead of running

# --- Options -------------------------------------------------------------------
setopt AUTO_CD                # `dotfiles` alone cds into it
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT   # `cd -<Tab>` lists recent dirs
setopt INTERACTIVE_COMMENTS   # allow `# comments` at the prompt
setopt EXTENDED_GLOB          # ^, ~ and (#q) glob operators
setopt NO_BEEP NO_FLOW_CONTROL   # no bell; Ctrl-S/Ctrl-Q are free for bindings

# --- Line editor -----------------------------------------------------------------
bindkey -e                    # emacs keys (zsh picks vi mode when $EDITOR mentions "vi")
WORDCHARS=${WORDCHARS//[\/.-]}   # Alt-Backspace stops at / . and -
zle_highlight+=(paste:none)   # pasted text isn't shown in reverse video

# Up/Down search history for lines starting with what you've typed so far.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search

# Word jumps: Alt/Ctrl + Left/Right (Ghostty sends Alt for the left Option key).
bindkey '^[[1;3D' backward-word '^[[1;3C' forward-word
bindkey '^[[1;5D' backward-word '^[[1;5C' forward-word
bindkey '^[[3~' delete-char   # Fn-Delete

# Ctrl-X Ctrl-E: edit the current command line in $EDITOR.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
