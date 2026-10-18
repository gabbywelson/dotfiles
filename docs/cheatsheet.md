# Cheat sheet

Every key binding, alias and helper this setup adds, plus the defaults worth knowing.
Keys are written for macOS; on Linux, Ghostty uses Ctrl-Shift where macOS uses Cmd.

## Ghostty

| Keys | Action |
| --- | --- |
| <kbd>Ctrl</kbd>+<kbd>`</kbd> | Drop-down terminal from anywhere (allow Accessibility the first time) |
| <kbd>Cmd</kbd>+<kbd>T</kbd> / <kbd>Cmd</kbd>+<kbd>N</kbd> | New tab / window |
| <kbd>Cmd</kbd>+<kbd>D</kbd> / <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>D</kbd> | Split right / down |
| <kbd>Cmd</kbd>+<kbd>Alt</kbd>+arrows | Move between splits |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+arrows | Resize the split |
| <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>Enter</kbd> | Zoom the split (again to restore) |
| <kbd>Cmd</kbd>+<kbd>↑</kbd> / <kbd>Cmd</kbd>+<kbd>↓</kbd> | Jump to the previous / next prompt |
| <kbd>Cmd</kbd>+<kbd>F</kbd>, <kbd>Cmd</kbd>+<kbd>G</kbd> | Search the scrollback, next match |
| <kbd>Cmd</kbd>+<kbd>K</kbd> | Clear the screen |
| <kbd>Cmd</kbd>+<kbd>Z</kbd> | Reopen the tab or split you just closed |
| <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> | Command palette |
| <kbd>Cmd</kbd>+<kbd>,</kbd> / <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>,</kbd> | Open / reload the config |
| Click in the command line | Move the cursor there |

The full list: `ghostty +list-keybinds --default`.

## Typing commands (zsh)

| Keys | Action |
| --- | --- |
| <kbd>→</kbd> or <kbd>End</kbd> | Accept the grey autosuggestion; <kbd>Alt</kbd>+<kbd>→</kbd> accepts one word |
| <kbd>↑</kbd> / <kbd>↓</kbd> | History, filtered to commands starting with what you've typed |
| <kbd>Ctrl</kbd>+<kbd>R</kbd> | atuin: search all history. <kbd>Ctrl</kbd>+<kbd>R</kbd> again cycles global → host → session → directory → workspace; <kbd>Enter</kbd> runs, <kbd>Tab</kbd> edits first |
| <kbd>Tab</kbd> | Fuzzy completion with previews (fzf-tab); <kbd>&lt;</kbd> <kbd>&gt;</kbd> switch groups |
| `**`<kbd>Tab</kbd> | fzf for any argument: `vim **<Tab>`, `kill **<Tab>`, `ssh **<Tab>` |
| <kbd>Ctrl</kbd>+<kbd>T</kbd> | Insert files picked with fzf (bat preview) |
| <kbd>Alt</kbd>+<kbd>C</kbd> | cd into a directory picked with fzf (tree preview) |
| <kbd>Alt</kbd>+<kbd>←</kbd>/<kbd>→</kbd> | Jump by word (<kbd>Ctrl</kbd> works too) |
| <kbd>Alt</kbd>+<kbd>Backspace</kbd> | Delete a word; stops at `/`, `.` and `-` |
| <kbd>Ctrl</kbd>+<kbd>A</kbd> / <kbd>Ctrl</kbd>+<kbd>E</kbd> | Start / end of line (also <kbd>Cmd</kbd>+<kbd>←</kbd>/<kbd>→</kbd>) |
| <kbd>Ctrl</kbd>+<kbd>U</kbd> / <kbd>Ctrl</kbd>+<kbd>K</kbd> | Delete to start / end of line |
| <kbd>Alt</kbd>+<kbd>.</kbd> | Insert the previous command's last argument (repeat to go further back) |
| <kbd>Ctrl</kbd>+<kbd>X</kbd> <kbd>Ctrl</kbd>+<kbd>E</kbd> | Edit the command line in your editor |
| <kbd>Ctrl</kbd>+<kbd>/</kbd> in any fzf list | Toggle the preview |

## Helpers

| Command | What it does |
| --- | --- |
| `dot …` | Manage the dotfiles (`dot help`) |
| `z part`, `zi` | Jump to a frequently used directory; `zi` picks interactively |
| `y [dir]` | Browse files in yazi; quit with <kbd>q</kbd> to land in the last directory |
| `rgf [query]` | Live ripgrep with previews; <kbd>Enter</kbd> opens the match in your editor |
| `proj` | Pick a project under `~/code` and cd into it |
| `lg` | lazygit, themed to match the terminal |
| `mkcd dir` | `mkdir -p` + `cd` |
| `ff` | System summary (fastfetch) |
| `reload` | Restart the shell after config changes |
| `catppuccin-flavor` | Prints `latte` or `mocha`, whichever the terminal shows |

### Aliases

| Group | Aliases |
| --- | --- |
| Listing | `ls`, `ll` (long, git status, relative times), `la`, `lt` / `lta` (tree), `t` (real `tree`, minus ignored files) |
| Viewing | `cat` → bat (plain when piped), `catp` (with pager) |
| Git | `g`, `gs`, `ga`, `gaa`, `gc`, `gcm`, `gp`, `gl`, `gd`, `gds`, `gdt` (difftastic), `gco`, `gcb`, `gb`, `gba`, `glog`, `gloga`, `gst`, `gstp` |
| Git (in `git` itself) | `git st`, `git lg`, `git last`, `git today`, `git who`, `git can`, `git unstage`, `git dft`, `git aliases` |
| JavaScript | `ni`, `nr`, `nrd`, `nrb`, `nrt`, `pi`, `pr`, `prd`, `prb`, `prt`, `px` |
| chezmoi | `cz`, `cze`, `cza`, `czd`, `czu`, `zshrc`, `aliases`, `gitconfig` (edit + apply) |
| Navigation | `..`, `...`, `....`, `-`, `code` (cd ~/code), `docs`, `dl` |
| macOS | `o`, `oo` (Finder here), `ip`, `localip`, `showfiles` / `hidefiles` |
| Linux | `localip`, `stacks`, `dps`, `dcu` / `dcd` / `dcl` / `dcp` (docker compose up/down/logs/ps) |

Type `alias` for all of them, or `which ll` for one.

## tmux

The prefix is <kbd>Ctrl</kbd>+<kbd>A</kbd>. On Linux servers, SSH logins attach to the
session `main` automatically (`NOTMUX=1 ssh host` to skip once, `touch ~/.notmux` for good).

| Keys | Action |
| --- | --- |
| prefix <kbd>\|</kbd> / prefix <kbd>-</kbd> | Split side by side / stacked |
| prefix <kbd>c</kbd> | New window (same directory) |
| <kbd>Alt</kbd>+arrows | Move between panes (no prefix) |
| prefix <kbd>g</kbd> / <kbd>y</kbd> / <kbd>f</kbd> | Popup: lazygit / yazi / fuzzy session switcher |
| prefix <kbd>[</kbd> | Scroll and copy: <kbd>v</kbd> selects, <kbd>y</kbd> copies to your Mac's clipboard (even over SSH) |
| prefix <kbd>d</kbd> | Detach (everything keeps running) |
| prefix <kbd>Ctrl</kbd>+<kbd>S</kbd> / <kbd>Ctrl</kbd>+<kbd>R</kbd> | Save / restore sessions (also saved every 15 minutes) |
| prefix <kbd>r</kbd> | Reload `~/.tmux.conf` |
| prefix <kbd>I</kbd> / prefix <kbd>U</kbd> | Install / update plugins |
| <kbd>Ctrl</kbd>+<kbd>A</kbd> <kbd>Ctrl</kbd>+<kbd>A</kbd> | Send the prefix to a nested tmux (Mac tmux → SSH → server tmux) |

## lazygit (`lg`)

<kbd>Space</kbd> stage · <kbd>a</kbd> stage all · <kbd>c</kbd> commit · <kbd>P</kbd> push ·
<kbd>p</kbd> pull · <kbd>\|</kbd> switch diff view (delta ↔ difftastic) · <kbd>z</kbd> undo ·
<kbd>[</kbd> <kbd>]</kbd> tabs · <kbd>?</kbd> all keys · <kbd>q</kbd> quit

## yazi (`y`)

Arrows or <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> move · <kbd>Enter</kbd> open ·
<kbd>Space</kbd> select · <kbd>y</kbd> / <kbd>x</kbd> / <kbd>p</kbd> copy / cut / paste ·
<kbd>a</kbd> new file (end with `/` for a folder) · <kbd>r</kbd> rename · <kbd>d</kbd> trash ·
<kbd>.</kbd> hidden files · <kbd>z</kbd> jump with zoxide · <kbd>s</kbd> / <kbd>S</kbd> search names / contents ·
<kbd>~</kbd> help · <kbd>q</kbd> quit
