#!/usr/bin/env bash
# Debian/Ubuntu bootstrap (pluto, charon, ...): packages, CLI toolbox, config,
# zsh as the login shell. Safe to rerun. Usually started by ../install.sh.
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
dot="$repo/home/dot_local/bin/executable_dot"
export DOTFILES_REPO=$repo
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
sudo=sudo; [ "$(id -u)" = 0 ] && sudo=
say() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }

bash "$dot" packages   # apt part; mise tools come after chezmoi lays down their list

# A UTF-8 locale, so zsh measures the prompt's glyphs correctly.
if ! locale -a 2>/dev/null | grep -qi '^en_US\.utf-\?8$'; then
  say "Generating the en_US.UTF-8 locale"
  $sudo sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
  $sudo locale-gen >/dev/null
fi

mkdir -p "$HOME/.local/bin" "$HOME/code"
if ! command -v mise >/dev/null 2>&1; then
  say "Installing mise"
  curl -fsSL https://mise.run | sh
fi
if ! command -v chezmoi >/dev/null 2>&1; then
  say "Installing chezmoi"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

say "Machine profile and git identity"
answers=(${DOTFILES_PROFILE:+--promptChoice "Machine profile=$DOTFILES_PROFILE"}
         ${DOTFILES_EMAIL:+--promptString "Git email=$DOTFILES_EMAIL"})
[ -t 0 ] || answers+=(--promptDefaults)   # unattended: take the defaults
chezmoi init --source "$repo" ${answers[@]+"${answers[@]}"}
say "Applying config"
chezmoi apply

say "Installing the CLI toolbox with mise (~/.config/mise/conf.d/dotfiles.toml)"
# GitHub rate-limits anonymous API calls; reuse a gh login when there is one.
if [ -z "${GITHUB_TOKEN:-}" ] && command -v gh >/dev/null 2>&1; then
  GITHUB_TOKEN=$(gh auth token 2>/dev/null || true); export GITHUB_TOKEN
fi
mise install --yes || echo "Some tools failed to install; rerun this script or \`mise install\` later." >&2
# An older bootstrap linked ~/.local/bin/bat to Debian's batcat; mise's bat replaces it.
if [ -L "$HOME/.local/bin/bat" ] && [ "$(readlink "$HOME/.local/bin/bat")" = /usr/bin/batcat ]; then
  rm "$HOME/.local/bin/bat"
fi
chezmoi init --source "$repo"   # again, now that delta exists for `chezmoi diff`

# Claude Code (native installer, self-updating, lands in ~/.local/bin).
command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash || true

if [ "$(getent passwd "$(id -un)" | cut -d: -f7)" != "$(command -v zsh)" ]; then
  say "Making zsh the login shell"
  $sudo chsh -s "$(command -v zsh)" "$(id -un)"
fi

bash "$dot" plugins

say "Checking the result"
"$HOME/.local/bin/dev-doctor" || true

cat <<'EOF'

Done. Log out and back in (or run `exec zsh -l`) to start using it.
  • Optional: `atuin login` to sync shell history between machines.
  • Later: `dot update` pulls and applies everything; `dot help` lists the rest.
EOF
