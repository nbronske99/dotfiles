#!/usr/bin/env bash
set -euo pipefail

version="0.12.4"
archive="nvim-linux-x86_64.tar.gz"
expected_sha256="012bf3fcac5ade43914df3f174668bf64d05e049a4f032a388c027b1ebd78628"
url="https://github.com/neovim/neovim/releases/download/v${version}/${archive}"
install_root="$HOME/.local/opt/nvim-${version}"
command_link="$HOME/.local/bin/nvim"

if [[ -x "$install_root/bin/nvim" ]]; then
    installed_version="$($install_root/bin/nvim --version | head -n 1)"
    if [[ "$installed_version" == "NVIM v${version}" ]]; then
        mkdir -p "$(dirname "$command_link")"
        if [[ -e "$command_link" && ! -L "$command_link" ]]; then
            echo "Refusing to replace non-symlink: $command_link" >&2
            exit 1
        fi
        ln -sfn "$install_root/bin/nvim" "$command_link"
        echo "Neovim ${version} is already installed."
        exit 0
    fi
fi

temporary_dir="$(mktemp -d)"
trap 'rm -rf "$temporary_dir"' EXIT
curl -fL "$url" -o "$temporary_dir/$archive"
actual_sha256="$(sha256sum "$temporary_dir/$archive" | cut -d' ' -f1)"
if [[ "$actual_sha256" != "$expected_sha256" ]]; then
    echo "Neovim checksum mismatch." >&2
    exit 1
fi
tar -xzf "$temporary_dir/$archive" -C "$temporary_dir"

if [[ -e "$install_root" ]]; then
    echo "Refusing to replace unexpected path: $install_root" >&2
    exit 1
fi
mkdir -p "$(dirname "$install_root")" "$(dirname "$command_link")"
mv "$temporary_dir/nvim-linux-x86_64" "$install_root"
if [[ -e "$command_link" && ! -L "$command_link" ]]; then
    echo "Installed Neovim, but refusing to replace non-symlink: $command_link" >&2
    exit 1
fi
ln -sfn "$install_root/bin/nvim" "$command_link"
echo "Installed Neovim ${version} at $install_root"

