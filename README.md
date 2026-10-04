# dotfiles

Personal config files for Linux machines. Managed via symlinks from ~/dotfiles/ into $HOME.

## Bootstrap on a new machine

    git clone git@github.com:nbronske99/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./bootstrap.sh --packages     # omit --packages to only (re)link configs

The bootstrap script backs up any existing configs to *.backup.<timestamp> before symlinking.
`--packages` also installs the C++ toolchain (g++, gdb, clangd, clang-tidy, clang-format),
tmux/fzf/ripgrep, Neovim 0.12.4 (checksummed, under ~/.local/opt), the VS Code extensions in
`vscode/extensions.txt`, and Claude Code.

## Tracked configs

- bashrc -> ~/.bashrc
- gitconfig -> ~/.gitconfig
- tmux.conf -> ~/.tmux.conf
- config/nvim/ -> ~/.config/nvim/
- vscode/settings.json, vscode/keybindings.json -> ~/.config/Code/User/
- bin/* -> ~/.local/bin/ (tmux-sessionizer)

## Two front-ends, one config

VS Code runs the real Neovim through vscode-neovim. `config/nvim/lua/config/lazy.lua` skips
every plugin under VS Code, and `lua/config/vscode.lua` maps the same leader keys to VS Code
commands, so `<leader>ff`, `<leader>rn`, `<leader>mb` (build), `<leader>ac` (Claude), F5/F9
(debug), and C-h/j/k/l mean the same thing in both editors.

Terminal nvim: native clangd (`lua/config/lsp.lua`), blink.cmp, nvim-dap through the same
cpptools adapter VS Code uses, claudecode.nvim, vim-tmux-navigator. Build/run/test keys call
the `cs` course CLI when it is on PATH (see the csc120 repo), otherwise plain g++.

tmux: prefix f opens the project sessionizer; copy-mode `y` goes to the system clipboard.
