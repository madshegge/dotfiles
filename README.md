# Dotfiles

Personal dotfiles configuration for zsh, git, and development tools.

## Overview

This repository contains configuration files for:
- **Zsh** - Shell configuration with oh-my-zsh, Powerlevel10k, and oh-my-posh
- **Git** - Git user configuration
- **Homebrew** - Package management via Brewfile
- **Oh-my-posh** - Prompt customization

## Prerequisites

Before installing, ensure you have:
- macOS or Linux (with [Homebrew](https://brew.sh)/Linuxbrew installed) —
  a few features (e.g. the `aerospace` cask) are macOS-only and are skipped
  automatically on Linux
- Git
- Zsh

## Installation

### Quick Install

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

The script will:
- Check for required dependencies
- Install Homebrew if not present (macOS)
- Create backups of existing dotfiles
- Create symlinks from `~/.dotfiles/` to `~/`
- Optionally install Homebrew packages

### Manual Installation

If you prefer to install manually:

```bash
# Create symlinks
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/.dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/zsh/.zshenv ~/.zshenv
ln -s ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/oh-my-posh/config.omp.json ~/config.omp.json
```

## Dependencies

### Required

- **oh-my-zsh** - Framework for managing zsh configuration
  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

- **Powerlevel10k** - Zsh theme
  ```bash
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  ```

- **oh-my-posh** - Prompt customization tool
  ```bash
  brew install oh-my-posh
  ```

### Zsh Plugins

The configuration uses the following oh-my-zsh plugins:
- `git` - Git aliases and functions
- `zsh-autosuggestions` - Command suggestions
- `zsh-syntax-highlighting` - Syntax highlighting
- `web-search` - Web search shortcuts

Install custom plugins:
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Optional Tools

- **NVM** (Node Version Manager)
  ```bash
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  ```

- **pyenv** (Python Version Manager)
  ```bash
  brew install pyenv
  ```

- **Rust/Cargo**
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

## Homebrew Packages

The `homebrew/Brewfile` contains all installed Homebrew formulas and casks.

To install all packages:
```bash
brew bundle --file ~/.dotfiles/homebrew/Brewfile
```

To update the Brewfile after installing new packages:
```bash
brew bundle dump --file ~/.dotfiles/homebrew/Brewfile
```

## Configuration Details

### Zsh Configuration

- **`.zshrc`** - Main zsh configuration
  - Uses oh-my-zsh framework
  - Powerlevel10k theme
  - oh-my-posh prompt customization
  - NVM, pyenv, and Rust environment setup
  - Custom PATH configurations

- **`.p10k.zsh`** - Powerlevel10k theme configuration
  - Customized prompt segments and colors
  - Run `p10k configure` to regenerate

- **`.zshenv`** - Environment variables loaded for all zsh sessions
  - Sources Rust/Cargo environment

- **`.zprofile`** - Profile settings loaded for login shells
  - Python PATH configuration
  - pyenv setup

### Git Configuration

- **`.gitconfig`** - Git user settings
  - User name and email
  - Git LFS configuration
  - Credential helper

### Oh-my-posh Configuration

- **`config.omp.json`** - Prompt theme configuration
  - Custom color palette
  - Git status segments
  - Language version indicators

## Notes

- All paths use `$HOME` instead of hardcoded usernames for portability
- Directories like `.npm-global` are created automatically by npm/yarn when configuring global paths
- The install script creates backups of existing files before creating symlinks
- The script is idempotent - safe to run multiple times

## Updating

After making changes to dotfiles:

1. Commit changes:
   ```bash
   cd ~/.dotfiles
   git add .
   git commit -m "Update dotfiles"
   git push
   ```

2. On a new machine, pull the latest changes:
   ```bash
   cd ~/.dotfiles
   git pull
   ```

## Troubleshooting

### Symlinks not working

If symlinks aren't being created, check:
- The dotfiles directory exists at `~/.dotfiles`
- You have write permissions in your home directory
- Existing files aren't blocking symlink creation (backups are created automatically)

### Theme not loading

If Powerlevel10k or oh-my-posh themes aren't loading:
- Ensure oh-my-zsh is installed
- Verify Powerlevel10k is in the correct directory
- Check that oh-my-posh is installed via Homebrew
- Restart your terminal or run `source ~/.zshrc`

### Homebrew packages fail to install

Some packages may require manual intervention or have dependencies. Review the Brewfile and install packages individually if needed.

## License

Personal configuration - use at your own discretion.

