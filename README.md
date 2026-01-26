# Dotfiles

My personal dotfiles for a fast, aesthetic macOS development environment.

> **Shell startup time: <100ms** (vs 500ms+ with oh-my-zsh)

## What's Included

| Component | Tool | Why |
|-----------|------|-----|
| Shell | **Zsh + Antidote** | Fast plugin loading, no oh-my-zsh bloat |
| Prompt | **Starship** | Beautiful, fast (Rust), cross-shell |
| Terminal | **Ghostty** | Modern, GPU-accelerated |
| Theme | **Catppuccin Mocha** | Consistent colors everywhere |
| Dotfiles | **Chezmoi** | Easy management, one-line install |

### Modern CLI Tools

| Old | New | Why |
|-----|-----|-----|
| `cat` | `bat` | Syntax highlighting |
| `ls` | `eza` | Icons, git integration |
| `find` | `fd` | Faster, intuitive |
| `grep` | `rg` (ripgrep) | 10-100x faster |
| `cd` | `zoxide` | Remembers frequent dirs |
| `git diff` | `delta` | Side-by-side, pretty |

Plus: `lazygit`, `fzf`, `gh`, `tldr`, `jq`

---

## Quick Start

### Fresh Mac (One Command!)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply gabbywelson
```

This will:
1. Install chezmoi
2. Clone the dotfiles repo
3. Prompt if this is a work machine (sets git email accordingly)
4. Install Homebrew (if needed)
5. Install all packages from Brewfile
6. Apply all config files

### After Install

```bash
# 1. Restart your terminal (required for PATH updates)
exec zsh

# 2. In Ghostty: set font to "MesloLGS Nerd Font"
```

> **Note:** Git name/email are configured automatically based on whether you selected "work machine" during setup.

---

## File Structure

```
~/dotfiles/
├── .chezmoi.toml.tmpl          # Chezmoi config (prompts for work/personal)
├── Brewfile                    # All Homebrew packages
├── dot_zshrc                   # → ~/.zshrc
├── dot_zsh_plugins.txt         # → ~/.zsh_plugins.txt
├── dot_gitconfig.tmpl          # → ~/.gitconfig (templated for work/personal email)
├── dot_config/
│   ├── starship.toml           # → ~/.config/starship.toml
│   └── ghostty/
│       └── config              # → ~/.config/ghostty/config
└── .chezmoiscripts/
    └── run_once_before_...     # Bootstrap script (installs Homebrew, packages)
```

Files prefixed with `dot_` become dotfiles (e.g., `dot_zshrc` → `~/.zshrc`).

---

## Key Aliases

### File Operations
| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | Pretty file listing |
| `ll` | `eza -la --icons --git` | Detailed with git status |
| `lt` | `eza --tree --level=2` | Tree view |
| `cat` | `bat` | Syntax highlighted |

### Git
| Alias | Command | Description |
|-------|---------|-------------|
| `gs` | `git status -sb` | Short status |
| `lg` | `lazygit` | Visual git TUI |
| `glog` | `git log --graph...` | Pretty log |
| `gco` | `git checkout` | Checkout |

### Navigation
| Alias | Description |
|-------|-------------|
| `..` | Go up one directory |
| `...` | Go up two directories |
| `z <partial>` | Jump to frequent directory (zoxide) |

### Chezmoi
| Alias | Command | Description |
|-------|---------|-------------|
| `cze` | `chezmoi edit` | Edit a managed file |
| `cza` | `chezmoi apply` | Apply changes |
| `czd` | `chezmoi diff` | See pending changes |

---

## Customization

### Adding New Dotfiles

```bash
# Add an existing file to chezmoi management
chezmoi add ~/.some-config

# Edit a managed file (opens in Cursor)
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply
```

### Adding Zsh Plugins

1. Edit `~/.zsh_plugins.txt`
2. Add plugin as `user/repo` (one per line)
3. Reload: `source ~/.zshrc`

Example:
```
# Add to ~/.zsh_plugins.txt
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-autosuggestions
```

### Changing the Theme

The **Catppuccin Mocha** theme is used everywhere. To change:

1. **Ghostty**: Edit `~/.config/ghostty/config`
   ```
   theme = dracula  # or: tokyo-night, nord, one-dark
   ```

2. **Starship**: Edit `~/.config/starship.toml`
   - Change `palette = "catppuccin_mocha"` to another palette

3. **fzf**: Edit `~/.zshrc`
   - Update `FZF_DEFAULT_OPTS` colors

### Adding Homebrew Packages

```bash
# Add to Brewfile, then:
brew bundle --file=~/dotfiles/Brewfile
```

---

## Maintenance

### Update Dotfiles

```bash
# Pull latest from GitHub
chezmoi update

# Or manually:
chezmoi git pull
chezmoi apply
```

### Update Packages

```bash
# Update Homebrew packages
brew update && brew upgrade

# Update zsh plugins
antidote update
```

### Check Shell Startup Time

```bash
# Should be <100ms
time zsh -i -c exit

# Detailed profiling
zmodload zsh/zprof
source ~/.zshrc
zprof
```

---

## Troubleshooting

### Icons Not Showing

Make sure Ghostty is using a Nerd Font:
1. Open Ghostty
2. Check that font is set to `MesloLGS Nerd Font` in config

### Slow Shell Startup

Profile your shell:
```bash
zmodload zsh/zprof
source ~/.zshrc
zprof | head -20
```

Common causes:
- Too many plugins in `~/.zsh_plugins.txt`
- Slow tool initializations

### Command Not Found

```bash
# Reinstall all packages
brew bundle --file=~/dotfiles/Brewfile

# Check if tool is installed
which bat eza fd rg fzf zoxide
```

### Zsh Completions Broken

```bash
# Rebuild completion cache
rm -f ~/.zcompdump*
compinit
```

---

## How It Works

### Chezmoi

Chezmoi manages your dotfiles by:
1. Storing source files in `~/dotfiles/` (or `~/.local/share/chezmoi/`)
2. Applying them to your home directory
3. Running scripts before/after apply

Key commands:
- `chezmoi add <file>` - Start managing a file
- `chezmoi edit <file>` - Edit the source
- `chezmoi diff` - See pending changes
- `chezmoi apply` - Apply changes
- `chezmoi update` - Pull and apply from GitHub

### Antidote

Antidote is a fast zsh plugin manager that:
1. Reads plugins from `~/.zsh_plugins.txt`
2. Generates a static `~/.zsh_plugins.zsh` file
3. Sources that file (fast!)

This is much faster than oh-my-zsh because there's no dynamic plugin loading.

### Starship

Starship is a cross-shell prompt written in Rust. It's:
- Fast (no noticeable delay)
- Configurable via `~/.config/starship.toml`
- Shows: directory, git status, node version, command duration

---

## Credits

- [Chezmoi](https://www.chezmoi.io/) - Dotfiles manager
- [Starship](https://starship.rs/) - Prompt
- [Antidote](https://antidote.sh/) - Zsh plugin manager
- [Catppuccin](https://catppuccin.com/) - Color theme
- [Ghostty](https://ghostty.org/) - Terminal
