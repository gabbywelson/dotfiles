#!/usr/bin/env bash
# Set up a new machine (macOS, or Debian/Ubuntu) from scratch:
#
#   curl -fsSL https://raw.githubusercontent.com/gabbywelson/dotfiles/main/install.sh | bash
#
# Optional env vars:
#   DOTFILES_PROFILE=personal|work   skip the profile question (default: ask; personal)
#   DOTFILES_DIR=~/dotfiles          where to clone the repo
#
# Safe to rerun. On a machine that already has the repo, it pulls and re-bootstraps,
# which is also how you upgrade an older checkout to the current layout.
set -euo pipefail

main() {
  local dir=${DOTFILES_DIR:-$HOME/dotfiles}
  local url=https://github.com/gabbywelson/dotfiles.git
  local os
  os=$(uname -s)

  local tilde="~"
  say "Dotfiles → ${dir/#$HOME/$tilde}"

  # 1. git, so we can clone.
  if [ "$os" = Darwin ]; then
    if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
      say "Installing Homebrew (it brings git via the Xcode Command Line Tools)"
      local brew_install
      brew_install=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
      if { : </dev/tty; } 2>/dev/null; then
        /bin/bash -c "$brew_install" </dev/tty
      else
        NONINTERACTIVE=1 /bin/bash -c "$brew_install"
      fi
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -r /etc/debian_version ]; then
    if ! command -v git >/dev/null 2>&1; then
      local sudo=sudo; [ "$(id -u)" = 0 ] && sudo=
      $sudo apt-get update -qq && $sudo apt-get install -y git curl ca-certificates
    fi
  else
    echo "Unsupported system: $os (this repo bootstraps macOS and Debian/Ubuntu)." >&2
    exit 1
  fi

  # 2. Clone, or update an existing checkout.
  if [ -d "$dir/.git" ]; then
    if [ -z "$(git -C "$dir" status --porcelain)" ]; then
      git -C "$dir" pull --rebase --quiet || say "Couldn't pull; continuing with the local checkout"
    else
      say "Local changes in $dir; skipping pull"
    fi
  else
    git clone --quiet "$url" "$dir"
    # Fetch over HTTPS (no key needed); push over SSH once you have a key.
    git -C "$dir" remote set-url --push origin git@github.com:gabbywelson/dotfiles.git
  fi

  # 3. Platform bootstrap. Prompts need the keyboard, not this piped script.
  local script="$dir/scripts/bootstrap-debian.sh"
  [ "$os" = Darwin ] && script="$dir/scripts/bootstrap-darwin.sh"
  if [ ! -t 0 ] && { : </dev/tty; } 2>/dev/null; then
    exec bash "$script" </dev/tty
  else
    exec bash "$script"
  fi
}

say() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }

main "$@"
