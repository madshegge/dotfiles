#!/bin/bash

# Dotfiles Installation Script
# This script sets up symlinks from ~/.dotfiles to ~/ for all configuration files

set -e  # Exit on error

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Check OS
check_os() {
    if [[ "$OSTYPE" != "darwin"* && "$OSTYPE" != "linux-gnu"* ]]; then
        warning "This script is designed for macOS and Linux (with Homebrew/Linuxbrew). Some features may not work on other systems."
    fi
}

# Check for required dependencies
check_dependencies() {
    info "Checking dependencies..."

    if ! command -v git &> /dev/null; then
        error "git is not installed. Please install git first."
        exit 1
    fi

    if ! command -v zsh &> /dev/null; then
        if command -v brew &> /dev/null; then
            info "zsh not found. Installing via Homebrew..."
            brew install zsh
        else
            error "zsh is not installed. Please install zsh first."
            exit 1
        fi
    fi

    success "All required dependencies are installed"
}

# Install Homebrew if not present (macOS only; Linux users are expected to
# already have Linuxbrew set up per https://brew.sh)
install_homebrew() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command -v brew &> /dev/null; then
            info "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            success "Homebrew installed"
        else
            info "Homebrew is already installed"
        fi
    fi
}

# Create backup of existing files
backup_existing() {
    local target_file="$1"
    local backup_path="$BACKUP_DIR/$(basename "$target_file")"
    
    if [[ -e "$target_file" ]] || [[ -L "$target_file" ]]; then
        if [[ ! -d "$BACKUP_DIR" ]]; then
            mkdir -p "$BACKUP_DIR"
        fi
        info "Backing up $target_file to $backup_path"
        cp -r "$target_file" "$backup_path" 2>/dev/null || true
    fi
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Remove existing file/symlink if it exists
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
            info "Symlink already exists: $target -> $source"
            return 0
        fi
        backup_existing "$target"
        rm -rf "$target"
    fi
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -s "$source" "$target"
    success "Created symlink: $target -> $source"
}

# Install dotfiles
install_dotfiles() {
    info "Installing dotfiles..."
    
    # Zsh files
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
    create_symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
    
    # Git config
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    
    # Oh-my-posh config
    create_symlink "$DOTFILES_DIR/oh-my-posh/config.omp.json" "$HOME/config.omp.json"
    
    success "All dotfiles installed"
}

# Install Homebrew packages (optional; works with Homebrew on macOS or
# Linuxbrew on Linux)
install_homebrew_packages() {
    if command -v brew &> /dev/null; then
        local brewfile="$DOTFILES_DIR/homebrew/Brewfile"
        if [[ -f "$brewfile" ]]; then
            read -p "Do you want to install Homebrew packages from Brewfile? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                info "Installing Homebrew packages..."
                brew bundle --file="$brewfile"
                success "Homebrew packages installed"
            else
                info "Skipping Homebrew package installation"
            fi
        fi
    fi
}

# Main installation function
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Dotfiles Installation Script        ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Check if dotfiles directory exists
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        error "Dotfiles directory not found: $DOTFILES_DIR"
        error "Please make sure you're running this script from the correct location."
        exit 1
    fi
    
    check_os
    check_dependencies
    
    read -p "This will create symlinks and may backup existing files. Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Installation cancelled"
        exit 0
    fi
    
    install_homebrew
    install_dotfiles
    install_homebrew_packages
    
    echo ""
    success "Installation complete!"
    if [[ -d "$BACKUP_DIR" ]]; then
        info "Backups are stored in: $BACKUP_DIR"
    fi
    info "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
}

# Run main function
main

