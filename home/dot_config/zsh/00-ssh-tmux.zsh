# Linux over SSH: land in the persistent tmux session "main", so a dropped
# connection never kills your work. Runs first: `exec` replaces this shell.
#
# Skip once with `LC_NOTMUX=1 ssh host` (ssh forwards LC_* variables; a plain
# NOTMUX wouldn't arrive), or for good with `touch ~/.notmux` on the server.
# Non-interactive SSH, scp, rsync and editor remotes (VS Code, Cursor) never attach.
# Nested inside a local tmux? Press Ctrl-a Ctrl-a to reach the inner one.

# An unknown $TERM (no terminfo for it on this host) would make tmux exit, and
# with it the whole SSH login. Fall back to one every host knows.
if [[ -n $SSH_CONNECTION && $TERM != dumb ]] && (( $+commands[infocmp] )) && ! infocmp $TERM &>/dev/null; then
  export TERM=xterm-256color
fi

if [[ $OSTYPE == linux* && -o interactive && -n $SSH_TTY && -z $TMUX && -z $NOTMUX && -z $LC_NOTMUX \
      && ! -e ~/.notmux && $TERM != dumb && $TERM_PROGRAM != vscode \
      && -z $VSCODE_IPC_HOOK_CLI ]] && (( $+commands[tmux] )); then
  exec tmux new-session -A -s main
fi
