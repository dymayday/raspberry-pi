#!/bin/bash

# Let's handle the 'zgen' installation process here

# Gather some info about the whereabouts of the zgen directory
# source $HOME/.profile

if [[ ! -s $ZGEN_HOME/zgen.zsh ]]; then
    git clone https://github.com/tarjoilija/zgen.git "$ZGEN_HOME"
fi

# Install all the plugins we need to have a happy life as a developer :)
if [[ -s $ZGEN_HOME/zgen.zsh ]]; then
    export ZGEN_DIR="$ZGEN_HOME"
    source "$ZGEN_HOME/zgen.zsh"

    # check if there's an init.zsh file for zgen and generate one if not.
    if ! zgen saved; then
        zgen oh-my-zsh

        # If zsh-syntax-highlighting is bundled after zsh-history-substring-search,
        # they break, so get the order right.
        zgen load zsh-users/zsh-syntax-highlighting
        zgen load zsh-users/zsh-history-substring-search

        # Automatically run zgen update and zgen selfupdate every 7 days
        zgen load unixorn/autoupdate-zgen

        # Load some oh-my-zsh plugins
        zgen oh-my-zsh plugins/sudo
        zgen oh-my-zsh plugins/colored-man-pages
        zgen oh-my-zsh plugins/colorize
        # zgen oh-my-zsh plugins/tmux
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/github
        # zgen load unixorn/git-extra-commands

        zgen oh-my-zsh plugins/python
        # Load more completion files for zsh from the zsh-lovers github repo
        zgen load zsh-users/zsh-completions src

        zgen load chrissicool/zsh-256color

        # Very cool plugin that generates zsh completion functions for commands
        # if they have getopt-style help text. It doesn't generate them on the fly,
        # you'll have to explicitly generate a completion, but it's still quite cool.
        zgen load RobSis/zsh-completion-generator

        # Add Fish-like autosuggestions to your ZSH
        zgen load zsh-users/zsh-autosuggestions

        # k is a zsh script / plugin to make directory listings more readable,
        # adding a bit of color and some git status information on files and directories
        # zgen load rimraf/k
        zgen load supercrabtree/k
        zgen load caiogondim/bullet-train-oh-my-zsh-theme bullet-train

        zgen load esc/conda-zsh-completion
        # fpath+="$ZGEN_HOME/esc/conda-zsh-completion-master"
        # compinit conda

        zgen save

        alias k="k -h"

        expand-or-complete-with-dots() {
            echo -n "\e[31m...\e[0m"
            zle expand-or-complete
            zle redisplay
        }
        zle -N expand-or-complete-with-dots
        bindkey "^I" expand-or-complete-with-dots

        # export TERM=rxvt

    fi
fi
