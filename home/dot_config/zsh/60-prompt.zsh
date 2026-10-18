# Prompt: starship (~/.config/starship.toml) plus a transient prompt.

[[ $TERM != dumb ]] || return 0
_cached_eval starship init zsh

# Transient prompt: once you press Enter, the full two-line prompt above the
# command collapses to a single ❯, so scrollback reads as a clean list of
# commands. Don't want it? Delete this block. (Technique from romkatv; plays
# well with Ghostty's shell integration, fzf-tab, autosuggestions and atuin.)
if (( $+functions[prompt_starship_precmd] )); then
  _transient_prompt_line_init() {
    emulate -L zsh
    [[ $CONTEXT == start ]] || return 0   # not for continuation lines or vared
    local -i ret
    while true; do
      zle .recursive-edit
      ret=$?
      [[ $ret == 0 && $KEYS == $'\4' ]] || break   # Ctrl-D on an empty line:
      [[ -o ignore_eof ]] || exit 0                # exit like a normal shell
    done
    local saved_prompt=$PROMPT saved_rprompt=$RPROMPT
    POSTDISPLAY=   # drop any autosuggestion ghost text from the collapsed line
    PROMPT='%(?.%F{green}.%F{red})❯%f '
    RPROMPT=''
    zle .reset-prompt
    PROMPT=$saved_prompt RPROMPT=$saved_rprompt
    if (( ret )); then
      zle .send-break
    else
      zle .accept-line
    fi
    return ret
  }
  zle -N zle-line-init _transient_prompt_line_init
fi
