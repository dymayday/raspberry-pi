#!/bin/bash

# This is where we install all the plugins and extensions 
# that we need to work happily with 'Vim' =]

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# First, let's copy paste the right configuration file
cp ${DIR}/vimrc $HOME/.vimrc

# Let's check if the backup directory exists, and create it if it doesn't
[ ! -s $HOME/.vim.backup ] && mkdir $HOME/.vim.backup

# Vim plugin manager install part:

# # Let's install 'Vundle', a plugins helper for Vim
# BUNDLE_DIR="$HOME/.vim/bundle"
#
# ### Vundle plugin manager ###
# # Install the plugin manager
# if [[ ! -s $BUNDLE_DIR/Vundle.vim ]]; then
#
#     # Let's clen up any previous install
#     [ -s $BUNDLE_DIR ] && rm -rf $BUNDLE_DIR
#     mkdir -p $BUNDLE_DIR && git clone https://github.com/VundleVim/Vundle.vim.git $BUNDLE_DIR/Vundle.vim
#
#     # Fuzzy finder handler
#     [ -s $HOME/.fzf ] && rm -rf $HOME/.fzf
#     mkdir -p $HOME/.fzf && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
#
# fi


### Vim-Plug plugin manager ###
VPDIR="$HOME/.vim/autoload/plug.vim"
if [[ ! -s $VPDIR ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Fuzzy finder handler
    [ -s $HOME/.fzf ] && rm -rf $HOME/.fzf
    mkdir -p $HOME/.fzf && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install

fi

# And then, let's install the plugins from the configuration file: 'vimrc'
vim +PlugClean +qall
# vim +PluginInstall +qall
vim +PlugUpdate +qall
