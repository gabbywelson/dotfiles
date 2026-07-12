#!/usr/bin/env bash
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
mapfile -t packages < <(grep -Ev '^($|#)' "$repo/packages/debian.txt")
sudo apt-get update
sudo apt-get install -y "${packages[@]}"

mkdir -p "$HOME/.local/bin" "$HOME/code"
command -v fd >/dev/null 2>&1 || ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
command -v bat >/dev/null 2>&1 || ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"

if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

chezmoi init --source "$repo" --apply
echo "Bootstrap complete. Run: dev-doctor"
