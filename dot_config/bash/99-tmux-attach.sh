if [[ $- == *i* ]] \
   && [ -n "${SSH_TTY:-}" ] \
   && [ -z "${TMUX:-}" ] \
   && [ -z "${NOTMUX:-}" ] \
   && [ ! -e "$HOME/.notmux" ] \
   && [ "${TERM:-dumb}" != dumb ] \
   && [ "${TERM_PROGRAM:-}" != vscode ] \
   && [ -z "${VSCODE_IPC_HOOK_CLI:-}" ] \
   && command -v tmux >/dev/null 2>&1; then
  exec tmux new-session -A -s main
fi
