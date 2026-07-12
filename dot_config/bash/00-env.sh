case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) PATH="$HOME/.local/bin:$PATH" ;;
esac
export PATH EDITOR=vim VISUAL=vim
export LESS='-R -F -i'

if [ -n "${TERM:-}" ] && [ "$TERM" != dumb ] && command -v infocmp >/dev/null 2>&1 \
   && ! infocmp "$TERM" >/dev/null 2>&1; then
  export TERM=xterm-256color
fi
