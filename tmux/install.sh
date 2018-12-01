#!/bin/bash

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ -s $TPM_DIR ]]; then rm -rf $TPM_DIR ; fi
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
cp tmux.conf $HOME/.tmux.conf
