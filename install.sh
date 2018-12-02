#!/bin/bash

# Get the current path to return to it once we are done
PWD=`pwd`
# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

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
declare -a section_array=("terminal" "tmux" "vim" "neovim" "rust")
for section in "${section_array[@]}"; do
    echo "Setting up '${section}'..."
    # cd ${DIR}/${section}
    # bash install.sh
    bash ${DIR}/${section}/install.sh
    # cd -
    echo ""
done

# And then, let's return where we initially came from
cd ${PWD}
