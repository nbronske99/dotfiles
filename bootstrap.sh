#!/usr/bin/env bash
# Bootstrap dotfiles: symlink configs from this repo into $HOME

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        echo "  already linked: $dst"
        return
    fi

    if [[ -e "$dst" ]]; then
        local backup="${dst}.backup.$(date +%Y%m%d-%H%M%S)"
        echo "  backing up existing $dst -> $backup"
        mv "$dst" "$backup"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  linked: $dst -> $src"
}

echo "Bootstrapping dotfiles from $DOTFILES_DIR"

link "$DOTFILES_DIR/bashrc"        "$HOME/.bashrc"
link "$DOTFILES_DIR/gitconfig"     "$HOME/.gitconfig"
link "$DOTFILES_DIR/tmux.conf"     "$HOME/.tmux.conf"
link "$DOTFILES_DIR/config/nvim"   "$HOME/.config/nvim"

echo "Done."
