#!/bin/bash

# This is where we install all the plugins and extensions 
# that we need to work happily with 'Vim' =]

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# First, let's copy paste the right configuration file
cp ${DIR}/vimrc $HOME/.vimrc

# Let's install 'Vundle', a plugins helper for Vim
if [[ ! -s $HOME/.vim/bundle/Vundle.vim ]]; then
    mkdir -p /opt/usr/.vim/bundle && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
    git clone --depth 1 https://github.com/junegunn/fzf.git /opt/usr/.fzf && /opt/usr/.fzf/install
fi

# And then, let's install the plugins from the configuration file: 'vimrc'
vim +PluginUpdate +qall
