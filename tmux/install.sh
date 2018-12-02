#!/bin/bash

# Defining the directory of the plugin manager
TPM_DIR="$HOME/.tmux/plugins/tpm"

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Let's clean up potential previous installs
[ -s $TPM_DIR ] && rm -rf $TPM_DIR

# And install the plugin manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# And the configuration file
cp ${DIR}/tmux.conf $HOME/.tmux.conf
