#!/usr/bin/env bash
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file "$repo/Brewfile"
mkdir -p "$HOME/code" "$HOME/Documents/Notes" "$HOME/archive"
chezmoi init --source "$repo" --apply
echo "Bootstrap complete. Run: dev-doctor"
