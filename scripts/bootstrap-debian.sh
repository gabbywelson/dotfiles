#!/usr/bin/env bash
# Bring a Debian host (pluto, charon, ...) to the full dev setup. Safe to rerun.
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
mapfile -t packages < <(grep -Ev '^($|#)' "$repo/packages/debian.txt")
sudo apt-get update
sudo apt-get install -y "${packages[@]}"

mkdir -p "$HOME/.local/bin" "$HOME/code"
# Debian renames these two binaries.
command -v fd >/dev/null 2>&1 || ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
command -v bat >/dev/null 2>&1 || ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi
if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi

# Runtimes and tools Debian doesn't package well: Node LTS (agents, web work),
# mikefarah yq (Debian's yq is a different tool), and the Codex CLI.
mise use -g node@lts yq npm:@openai/codex
mise reshim

# Claude Code (native installer, self-updating, lands in ~/.local/bin).
command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

chezmoi init --source "$repo" --apply

# tmux plugins (catppuccin, resurrect, continuum) via tpm.
"$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null || true

# zsh as the login shell.
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
  sudo chsh -s "$(command -v zsh)" "$USER"
fi

tldr --update >/dev/null 2>&1 || true
echo "Bootstrap complete. Start a new shell, then run: dev-doctor"
