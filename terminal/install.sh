#!/bin/bash

declare -a shell_array=("bash" "zsh")
for shell_name in "${shell_array[@]}"; do
    echo "Setting up '${shell_name}'..."
    # bash ${shell_name}/
    cp ./${shell_name}/${shell_name}rc $HOME/.${shell_name}rc
done

# Next, we focus on the common parts
cp ./profile $HOME/.profile
cp ./bash/bash_aliases $HOME/.bash_aliases
cp ./bash/bash_profile $HOME/.bash_profile