#!/bin/bash

# This is the 'NeoVim' install script
# This is where we install all the plugins and extensions 
# that we need to work happily with 'NeoVim' =]

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# First, let's copy paste the right configuration file
cp ${DIR}/init.vim $HOME/.config/nvim/init.vim

# Let's check if the backup directory exists, and create it if it doesn't
[ ! -s $HOME/.vim.backup ] && mkdir $HOME/.vim.backup

# Let's clean up potential previous installs
[ -s $HOME/.config/nvim/plugged ] && rm -rf $HOME/.config/nvim/plugged

# And then, let's install the plugins from the NeoVim configuration file
nvim +PlugClean +qa && nvim +PlugInstall +UpdateRemotePlugins +qa && nvim +PlugUpdate +UpdateRemotePlugins +qa
