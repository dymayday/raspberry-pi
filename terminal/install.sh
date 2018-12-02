#!/bin/bash

# Get the directory path of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

declare -a shell_array=("bash" "zsh")
for shell_name in "${shell_array[@]}"; do
    echo "Setting up '${shell_name}'..."
    echo "Copying ${DIR}/${shell_name}/${shell_name}rc to $HOME/.${shell_name}rc"
    cp ${DIR}/${shell_name}/${shell_name}rc $HOME/.${shell_name}rc
    echo ""
done

# Next, we focus on the common parts
cp ${DIR}/profile $HOME/.profile
cp ${DIR}/bash/bash_aliases $HOME/.bash_aliases
cp ${DIR}/bash/bash_profile $HOME/.bash_profile

# Next, we need to install the zsh plugin manager
bash ${DIR}/zsh/zgen_install.sh
