#!/bin/bash

#set -x

# Set a variable of the real user
[ -z "$SUDO_USER" ] && real_user="$USER" || real_user="$SUDO_USER"

# Dotfile folder location
dotfiles="$HOME/dotfiles"

# List of packages to install
packages="build-essential git-core vim exuberant-ctags wget curl"

install_packages() {
    echo "Installing packages"
    apt-get install -y $packages
}

make_links() {
    echo "Creating symlinks in home folder."
    ln -fs "$dotfiles/bin" "$HOME/bin"
    ln -fs "$dotfiles/vim/vimrc" "$HOME/.vimrc"
    ln -fs "$dotfiles/vim" "$HOME/.vim"
    ln -fs "$dotfiles/git/config" "$HOME/.gitconfig"
}

install_packages

#set +x
