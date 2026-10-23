# How it works

The parts you need when you want to change something: how chezmoi maps this repo onto
your home directory, what happens when a shell starts, how the theme follows light and
dark mode, and recipes for common changes.

- [chezmoi in five minutes](#chezmoi-in-five-minutes)
- [What happens when you open a terminal](#what-happens-when-you-open-a-terminal)
- [Theming](#theming)
- [Linux servers](#linux-servers)
- [Settings that apps write: T3 Code, atuin](#settings-that-apps-write-t3-code-atuin)
- [Recipes](#recipes)
- [Troubleshooting](#troubleshooting)

## chezmoi in five minutes

[chezmoi](https://www.chezmoi.io) copies files from this repo (the *source*) into your
home directory (the *target*). The repo root has a `.chezmoiroot` file pointing at
`home/`, so only `home/` is source state; everything else is docs and scripts.

**File names carry instructions.** `home/dot_config/zsh/10-env.zsh` becomes
`~/.config/zsh/10-env.zsh`. The prefixes and suffixes used here:

| In the repo | Means |
| --- | --- |
| `dot_name` | `.name` |
| `private_` | permissions 0700/0600 (`private_dot_ssh` → `~/.ssh`) |
| `executable_` | chmod +x (`dot_local/bin/executable_dot` → `~/.local/bin/dot`) |
| `create_` | written once, never overwritten (btop rewrites its own config) |
| `*.tmpl` | a [Go template](https://www.chezmoi.io/user-guide/templating/), rendered per machine |

**Templates** see the OS (`.chezmoi.os`), hostname and the answers from
`chezmoi init`: `.profile` (`personal` or `work`), `.name` and `.email`. For example
`dot_gitconfig.tmpl` fills in your git identity and `private_dot_ssh/private_config.tmpl` only
adds homelab hosts on personal Macs. Test a template without applying it:

```sh
chezmoi cat ~/.ssh/config                                         # as this machine
chezmoi cat --override-data '{"profile":"work"}' ~/.ssh/config    # as a work machine
```

**The special files** in `home/`:

| File | Purpose |
| --- | --- |
| `.chezmoi.toml.tmpl` | The questions `chezmoi init` asks; generates `~/.config/chezmoi/chezmoi.toml` |
| `.chezmoiignore` | Targets to skip per OS or profile (no Ghostty or T3 Code settings on servers, no Linux toolbox on Macs) |
| `.chezmoiexternal.toml` | Things downloaded on apply: antidote, tpm and the Catppuccin themes for bat, delta, lazygit, btop and yazi |
| `.chezmoiremove` | Old targets to delete (files this repo used to manage) |
| `.chezmoiscripts/` | Scripts run on apply: rebuild bat's theme cache, set up the Orrery sync timer |

**Drift** is when a target no longer matches the repo, usually because an installer
appended a line to `~/.zshrc`. `dot status` and `dot doctor` list it, `dot diff` shows
it, and `chezmoi apply` asks before overwriting. Move anything worth keeping into the
repo (or a `*.local` file) first.

## What happens when you open a terminal

zsh reads its files in this order (login shells are every new Ghostty tab and every SSH
login):

1. **`~/.zshenv`**, for every zsh including scripts: `PATH` only (Homebrew, `~/.local/bin`,
   mise shims, bun, cargo, go, ...). Keep it fast: it runs for every `zsh -c`.
2. **`~/.zprofile`**, login shells: Homebrew's environment, then `~/.zshenv` again,
   because macOS's `path_helper` (in `/etc/zprofile`) has just moved system directories
   to the front of `PATH`.
3. **`~/.zshrc`**, interactive shells: sources `~/.config/zsh/*.zsh` in numeric order,
   then `~/.zshrc.local`.

| Module | Does |
| --- | --- |
| `00-ssh-term.zsh` | Over SSH, falls back to `TERM=xterm-256color` when the host lacks terminfo for `$TERM` |
| `10-env.zsh` | `$EDITOR` (Cursor, else nvim, else vim), bat man pages, `catppuccin-flavor` |
| `20-options.zsh` | History, shell options, key bindings |
| `30-completion.zsh` | `compinit` (full rebuild at most daily) and completion styles |
| `40-plugins.zsh` | antidote plugins from `plugins.txt` |
| `50-tools.zsh` | mise, direnv, zoxide, fzf, atuin |
| `60-prompt.zsh` | Starship and the transient prompt |
| `70-aliases.zsh` | Aliases (only for tools that are installed) |
| `80-functions.zsh` | `y`, `rgf`, `proj`, `mkcd`, `lazygit`, `dot` |

**Why startup is fast** (~85 ms on an M-series Mac):

- Tool init scripts (`starship init zsh`, `atuin init zsh`, ...) are cached in
  `~/.cache/zsh/init-*.zsh`. Each cache records the resolved binary path, so upgrading
  a tool rebuilds it automatically. `mise activate` is the exception: its output
  captures the current `PATH`, so it runs every time.
- antidote writes a static plugin bundle (`~/.cache/zsh/plugins.zsh`) and is only
  loaded again when `plugins.txt` changes.
- `compinit -C` skips the security audit except once a day.

Measure with `dot doctor`, or `hyperfine 'zsh -i -c exit'`. To find a slow line:
`zsh -xi -c exit 2>&1 | less`.

**The transient prompt** (`60-prompt.zsh`) wraps the line editor: when you press Enter,
it swaps the prompt for a bare `❯`, redraws, then runs the command. It's written to
coexist with Ghostty's shell integration (prompt marks, click-to-move), fzf-tab,
autosuggestions and atuin. Remove the block to turn it off.

## Theming

Ghostty switches between Catppuccin Latte and Mocha when macOS switches appearance. The
challenge is making every tool switch along with it. Each tool uses one of three
strategies:

| Strategy | Tools | How |
| --- | --- | --- |
| Use the terminal's palette | Starship, fzf, fzf-tab, eza, zsh highlighting, atuin, git | Colors are ANSI names (`blue`, `green`, ...) instead of hex codes, so Ghostty's active theme decides what they look like. Text already on screen recolors too. |
| Ask the terminal | bat (and man pages), yazi | They query the terminal's background color and pick `Catppuccin Latte` or `Catppuccin Mocha` themselves. |
| Told by the shell | delta, lazygit | `catppuccin-flavor` reads macOS's appearance. The shell exports `DELTA_FEATURES=catppuccin-<flavor>` at startup; the `lazygit` function layers `~/.config/lazygit/themes/<flavor>.yml` on each launch. |

Starship's pills use a trick: the text inside a pill is drawn with `inverted` colors,
which makes it the terminal's background color. That's dark text on a pastel pill in
Mocha and light text on a saturated pill in Latte, readable in both without separate
palettes.

btop paints its own Mocha background, which look deliberate in either mode.
On Linux there's no macOS appearance to read, so `catppuccin-flavor` says `mocha`; set
`CATPPUCCIN_FLAVOR=latte` in the environment to override.

## Linux servers

- **Packages**: apt installs the base system ([packages/debian.txt](../packages/debian.txt)).
  The CLI toolbox comes from upstream releases through mise
  ([home/dot_config/mise/conf.d/dotfiles.toml](../home/dot_config/mise/conf.d/dotfiles.toml)),
  because Debian's versions trail by years and several configs here need recent ones.
  `dot update` runs `mise upgrade`.
- **Completions**: mise-installed tools don't ship zsh completions, so `dot plugins`
  generates them into `~/.local/share/zsh/site-functions`.
- **Ghostty over SSH**: Ghostty installs its terminfo on each host the first time you
  connect (`ssh-terminfo`), so colors and keys work without fiddling.
- **Bash fallback**: `~/.bashrc` and `~/.config/bash/` keep bash pleasant for the times
  something drops you into it.

## Settings that apps write: T3 Code, atuin

Most files here are only ever edited in the repo. A few belong to apps that rewrite
them when you change a setting in their UI:

| App | Files in the repo | Not in the repo (and why) |
| --- | --- | --- |
| [T3 Code](https://t3.codes) | `~/.t3/userdata/settings.json` (providers, favorite and default models, worktree cleanup), `client-settings.json` (fonts, notifications, diff and sidebar preferences), `keybindings.json` (+ its `keybindings-migrations` marker) | `clerk-tokens.json` and `secrets/` (sign-in), `connection-catalog.json` (encrypted remote connections), `desktop-settings.json` (window position), `state*.sqlite`, `logs/`, `usage-*` caches, `worktrees/`; Electron's own data in `~/Library/Application Support/t3code*` |
| [atuin](https://atuin.sh) | `~/.config/atuin/config.toml` (a template) | `~/.local/share/atuin`: history, your sync login, the encryption key |

After changing something in T3 Code, `dot status` lists the file as drift. Then:

```sh
dot save                         # copy changes made on this machine into the repo
git -C ~/dotfiles diff           # review
git -C ~/dotfiles commit -am "t3: …" && git -C ~/dotfiles push
```

`dot save` only copies files changed on this machine (never repo changes you haven't
applied yet) and flags anything that looks like a password or token, because the repo
is public. If you run `dot update` with unsaved local changes, it tells you first, and
chezmoi asks before overwriting each file.

The atuin config is a template, so `dot save` skips it: change it with
`dot edit ~/.config/atuin/config.toml`. It turns on what `atuin setup` enables (the
background daemon, daemon-backed search, and atuin AI on `?`). AI is on for the
personal profile and off for work, so no work context reaches a third-party service
unless you decide it's allowed.

## Recipes

**Add a CLI tool everywhere**

1. macOS: add `brew "name"` to [packages/Brewfile](../packages/Brewfile).
2. Linux: add it to the [mise list](../home/dot_config/mise/conf.d/dotfiles.toml)
   (`mise registry name` shows if mise knows it), or to
   [packages/debian.txt](../packages/debian.txt) if Debian's version is fine.
3. Shell integration goes in `home/dot_config/zsh/50-tools.zsh`, guarded so machines
   without it don't break: `_cached_eval tool init zsh` or `(( $+commands[tool] )) && ...`.
4. Commit, push, then `dot update` on each machine.

**Add an alias or function**: `dot edit ~/.config/zsh/70-aliases.zsh` (or
`80-functions.zsh`). It opens the repo copy and applies it when you close the editor.

**Start managing a new config file**: `chezmoi add ~/.config/tool/config.toml` copies it
into `home/`. Add `--template` if it needs per-machine values.

**Add a zsh plugin**: append `owner/repo` to `home/dot_config/zsh/plugins.txt`; the next
shell clones and loads it.

**Change the font or font size on one machine**: put `font-size = 16` in
`~/.config/ghostty/config.local`.

**Different git email for some repos**: in `~/.gitconfig.local`,

```ini
[includeIf "gitdir:~/code/work/"]
    path = ~/.gitconfig.work
```

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Ghostty shows "Configuration Errors" | `ghostty +validate-config` names the line. Theme names are case-sensitive: `Catppuccin Mocha`, not `catppuccin-mocha` (Ghostty 1.2 renamed them). |
| Boxes or `?` instead of icons | You're in a terminal without Nerd Font symbols. Ghostty has them built in; elsewhere install JetBrains Mono Nerd Font. |
| Prompt glyphs misaligned on a server | The host lacks a UTF-8 locale. `bootstrap-debian.sh` generates `en_US.UTF-8`; check `locale`. |
| `dot update` says the repo has uncommitted changes | Commit or stash in `~/dotfiles` (`dot cd`), then rerun. |
| chezmoi complains about a missing `profile`/`email` key | The config predates profiles: run `chezmoi init` (or `dot update`). |
| A command is missing on a fresh machine | `dot packages`, then `dot doctor`. |
| Shell feels slow | `dot doctor` shows startup time; delete `~/.cache/zsh` to rebuild caches. |
| You want the old prompt back | Previous configs are in `~/archive/dotfiles-backup-2026-10-17` (MacBook) and in git history. |
