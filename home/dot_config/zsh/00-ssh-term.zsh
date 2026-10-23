# Over SSH, an unknown $TERM (no terminfo for it on this host) breaks full-screen
# programs and line editing. Fall back to one every host knows.
if [[ -n $SSH_CONNECTION && $TERM != dumb ]] && (( $+commands[infocmp] )) && ! infocmp $TERM &>/dev/null; then
  export TERM=xterm-256color
fi
