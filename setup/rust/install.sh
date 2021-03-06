#!/bin/bash
#curl https://sh.rustup.rs -sSf | sh

declare -a toolchain_arr=("stable" "beta" "nightly")

curl https://sh.rustup.rs -sSf > /tmp/rustup-init.sh
sh /tmp/rustup-init.sh -y
rm /tmp/rustup-init.sh

source $HOME/.cargo/env

#if [[ ! -s $HOME/.zfunc ]]; then mkdir $HOME/.zfunc fi
[ ! -s $HOME/.zfunc ] && mkdir $HOME/.zfunc
rustup completions zsh > ~/.zfunc/_rustup


for toolchain in "${toolchain_arr[@]}"; do
    rustup install $toolchain
    rustup component add rust-src --toolchain $toolchain
    rustup component add rust-analysis --toolchain $toolchain
    rustup component add rls-preview --toolchain $toolchain
    rustup component add rustfmt-preview --toolchain $toolchain
done

rustup default nightly

cargo install cargo-update ripgrep fd-find exa skim bat
