#!/bin/bash

# This is where we install all the plugins and extensions 
# that we need to work happily with 'Vim' =]

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# First, let's copy paste the right configuration file
cp ${DIR}/vimrc $HOME/.vimrc

# Let's check if the backup directory exists, and create it if it doesn't
[ ! -s $HOME/.vim.backup ] && mkdir $HOME/.vim.backup

# Let's install 'Vundle', a plugins helper for Vim
BUNDLE_DIR="$HOME/.vim/bundle"
if [[ ! -s $BUNDLE_DIR/Vundle.vim ]]; then
    mkdir -p $BUNDLE_DIR && git clone https://github.com/VundleVim/Vundle.vim.git ~/$BUNDLE_DIR/Vundle.vim
    mkdir -p $HOME/.fzf && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
    vim +PluginInstall +qall
    vim +PluginUpdate +qall
fi

# And then, let's install the plugins from the configuration file: 'vimrc'
# vim +PluginInstall +qall
# vim +PluginUpdate +qall
