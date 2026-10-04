#!/usr/bin/env bash
# Bootstrap dotfiles: symlink configs from this repo into $HOME
#
#   ./bootstrap.sh              symlinks only (safe to re-run)
#   ./bootstrap.sh --packages   also install the toolchain (apt, Neovim, VS Code
#                               extensions, Claude Code)

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

WITH_PACKAGES=0
for arg in "$@"; do
    case "$arg" in
        --packages) WITH_PACKAGES=1 ;;
        -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
        *) echo "unknown option: $arg" >&2; exit 2 ;;
    esac
done

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

install_packages() {
    echo "Installing toolchain packages (sudo)"
    sudo apt-get update
    sudo apt-get install -y \
        build-essential gdb cmake \
        clangd clang-format clang-tidy \
        git gh tmux fzf ripgrep fd-find xclip curl python3

    echo "Installing Neovim"
    "$DOTFILES_DIR/scripts/install-neovim.sh"

    if command -v code >/dev/null; then
        echo "Installing VS Code extensions"
        while read -r ext; do
            [[ -z "$ext" || "$ext" == \#* ]] && continue
            code --install-extension "$ext" --force >/dev/null && echo "  $ext"
        done < "$DOTFILES_DIR/vscode/extensions.txt"
    else
        echo "  VS Code not found: install the .deb from https://code.visualstudio.com, then re-run"
    fi

    if ! command -v claude >/dev/null; then
        echo "Installing Claude Code"
        curl -fsSL https://claude.ai/install.sh | bash
    fi
}

echo "Bootstrapping dotfiles from $DOTFILES_DIR"

link "$DOTFILES_DIR/bashrc"        "$HOME/.bashrc"
link "$DOTFILES_DIR/gitconfig"     "$HOME/.gitconfig"
link "$DOTFILES_DIR/tmux.conf"     "$HOME/.tmux.conf"
link "$DOTFILES_DIR/config/nvim"   "$HOME/.config/nvim"
link "$DOTFILES_DIR/vscode/settings.json"    "$HOME/.config/Code/User/settings.json"
link "$DOTFILES_DIR/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
for script in "$DOTFILES_DIR"/bin/*; do
    link "$script" "$HOME/.local/bin/$(basename "$script")"
done

if [[ $WITH_PACKAGES -eq 1 ]]; then
    install_packages
fi

echo "Done."
if [[ $WITH_PACKAGES -eq 1 ]]; then
    echo "One-time logins, if not done yet:  gh auth login   and   claude"
fi
