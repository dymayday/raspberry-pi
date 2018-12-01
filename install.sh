#!/bin/bash

# Setting up the package managers
UNAME=`uname -r`
if [[ "$UNAME" == *"ARCH" ]]; then
    # Let's update the packages sources
    sudo pacman -Syyu
    sudo pacman -S yaourt
    PACMAN="yaourt --noconfirm -S"
else
    # Let's update the packages sources
    sudo apt update
    PACMAN="sudo apt -y install"
fi

# Let's install the programs now
PACKAGES="vim neovim htop git"
echo "Installing ${PACKAGES}..."
$PACMAN $PACKAGES

# Let's loop on every section's directory and run their install script
declare -a section_array=("terminal" "tmux" "rust")
for section in "${section_array[@]}"; do
    echo "Setting up '${section}'..."
    # bash ./$section/install.sh
done
