# Linux over SSH: land in the persistent tmux session "main", so a dropped
# connection never kills your work. Runs first: `exec` replaces this shell.
#
# Skip once with `NOTMUX=1 ssh host`, or for good with `touch ~/.notmux`.
# Non-interactive SSH, scp, rsync and editor remotes (VS Code, Cursor) never attach.
# Nested inside a local tmux? Press Ctrl-a Ctrl-a to reach the inner one.

if [[ $OSTYPE == linux* && -o interactive && -n $SSH_TTY && -z $TMUX && -z $NOTMUX \
      && ! -e ~/.notmux && $TERM != dumb && $TERM_PROGRAM != vscode \
      && -z $VSCODE_IPC_HOOK_CLI ]] && (( $+commands[tmux] )); then
  exec tmux new-session -A -s main
fi
