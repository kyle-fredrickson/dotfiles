# Paths
export DOTFILES=$HOME/.dotfiles

# Language environment
export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"

# Set editor for local/remote
export EDITOR='nvim'

# Colors
export CLICOLOR=1

# Load config files
for config_file ("$DOTFILES"/zsh/*.zsh(N)); do
    source "$config_file"
done
unset config_file

# Custom keybindings.
bindkey -v
bindkey 'fd' vi-cmd-mode
bindkey ' ' magic-space

[ -f "/Users/kylefredrickson/.ghcup/env" ] && source "/Users/kylefredrickson/.ghcup/env" # ghcup-env

# Plugins
export ZPLUG_HOME=$HOME/.zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed.
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi


zplug load

