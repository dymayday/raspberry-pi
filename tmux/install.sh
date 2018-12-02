#!/bin/bash

# Defining the directory of the plugin manager
TPM_DIR="$HOME/.tmux/plugins/tpm"

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ -s $TPM_DIR ]]; then rm -rf $TPM_DIR ; fi
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
cp ${DIR}/tmux.conf $HOME/.tmux.conf
