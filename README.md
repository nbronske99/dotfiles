# dotfiles

Personal config files for Linux machines. Managed via symlinks from ~/dotfiles/ into $HOME.

## Bootstrap on a new machine

    git clone git@github.com:nbronske99/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./bootstrap.sh

The bootstrap script backs up any existing configs to *.backup.<timestamp> before symlinking.

## Tracked configs

- bashrc -> ~/.bashrc
- gitconfig -> ~/.gitconfig
- tmux.conf -> ~/.tmux.conf
- config/nvim/ -> ~/.config/nvim/
