# Dotfiles

One chezmoi-managed development environment for a macOS workstation and Debian
agent hosts. Zsh remains native on macOS, Bash remains native on Debian, and
Git, Starship, tmux, agent guidance, and helper commands are shared.

## Bootstrap

```sh
# macOS
./scripts/bootstrap-darwin.sh

# Debian
./scripts/bootstrap-debian.sh
```

Both scripts are safe to rerun. Package installation is explicit and is not
triggered by every `chezmoi apply`.

## Daily commands

```sh
chezmoi diff                 # inspect pending config changes
chezmoi apply                # apply managed config
dev-doctor                   # verify the toolchain and identity
dev-session open ~/code/app  # persistent tmux session for a repository
dev-session list
orrery search dockerhost      # search the shared Obsidian knowledge base
orrery sync --actor codex     # commit, rebase, and push durable updates
```

Interactive SSH sessions on Linux attach to tmux session `main`. Bypass once
with `NOTMUX=1`, disable it with `touch ~/.notmux`, or use a noninteractive SSH
command. scp, rsync, and VS Code Remote sessions do not auto-attach.

## Boundaries

- Active projects: `~/code`
- Personal documents and notes: `~/Documents`
- Inactive material and migration backups: `~/archive`
- Generated models and application data: `~/.local/share`
- Machine-local Bash overrides: `~/.config/bash/91-local-unmanaged.sh`

The repository intentionally does not manage agent credentials, histories,
session databases, plugin state, SSH private keys, or application caches.

Shared agent skills live under `~/.agents/skills`. Orrery is cloned at
`~/Documents/Notes/Orrery` on macOS and `~/vaults/orrery` on Linux. A launchd
job and user systemd timer conservatively synchronize the private Git-backed
vault every ten minutes.

## Rollback

Migration backups are dated under `~/archive/dev-env-migration-*` on macOS and
`~/dotfiles-backup-*` on Linux. Restore files from the latest backup, then start
a fresh shell. Always validate SSH startup in a second connection before ending
the first session.
