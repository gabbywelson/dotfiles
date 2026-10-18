#!/usr/bin/env bash
# macOS bootstrap: Homebrew, packages, config, plugins. Safe to rerun.
# Usually started by ../install.sh; run it directly from a checkout too.
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
dot="$repo/home/dot_local/bin/executable_dot"
export DOTFILES_REPO=$repo
say() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }

if [ ! -x /opt/homebrew/bin/brew ]; then
  say "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
command -v chezmoi >/dev/null 2>&1 || brew install chezmoi

say "Machine profile and git identity"
# Asked once; answers live in ~/.config/chezmoi/chezmoi.toml.
answers=(${DOTFILES_PROFILE:+--promptChoice "Machine profile=$DOTFILES_PROFILE"}
         ${DOTFILES_EMAIL:+--promptString "Git email=$DOTFILES_EMAIL"})
[ -t 0 ] || answers+=(--promptDefaults)   # unattended: take the defaults
chezmoi init --source "$repo" ${answers[@]+"${answers[@]}"}

# Ghostty downloaded from ghostty.org? Let Homebrew adopt it instead of failing on it.
if [ -d /Applications/Ghostty.app ] && ! brew list --cask ghostty >/dev/null 2>&1; then
  brew install --cask --adopt ghostty || true
fi
bash "$dot" packages

say "Applying config"
chezmoi init --source "$repo"   # again, now that delta exists for `chezmoi diff`
chezmoi apply

bash "$dot" plugins
mkdir -p "$HOME/code"

say "Checking the result"
"$HOME/.local/bin/dev-doctor" || true

cat <<'EOF'

Done. Next:
  • Open Ghostty (Ctrl-` toggles the drop-down terminal once you allow Accessibility).
  • Optional: `atuin login` to sync shell history between machines.
  • Later: `dot update` pulls and applies everything; `dot help` lists the rest.
EOF
