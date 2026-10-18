# Environment for interactive shells. (The $TERM fallback lives in 00-ssh-tmux.zsh.)

# --- Editor & pager ----------------------------------------------------------
if (( $+commands[cursor] )); then
  export EDITOR="cursor --wait"
elif (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export VISUAL=$EDITOR PAGER=less LESS="-R -F -i"

# Colorful man pages, rendered by bat.
if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'" MANROFFOPT="-c"
fi

# --- Catppuccin flavor ---------------------------------------------------------
# Ghostty switches between Catppuccin Latte and Mocha with macOS appearance.
# Most tools follow along on their own: the prompt, fzf and eza use the
# terminal's ANSI colors, and bat and yazi ask the terminal for its background.
# delta and lazygit need to be told, so this prints "latte" or "mocha".
# Set CATPPUCCIN_FLAVOR to pin one (Linux hosts default to mocha).
catppuccin-flavor() {
  if [[ -n $CATPPUCCIN_FLAVOR ]]; then
    print -r -- $CATPPUCCIN_FLAVOR
  elif [[ $OSTYPE == darwin* && $(defaults read -g AppleInterfaceStyle 2>/dev/null) != Dark ]]; then
    print latte
  else
    print mocha
  fi
}
export DELTA_FEATURES="catppuccin-$(catppuccin-flavor)"
