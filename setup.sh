#!/bin/bash

function install_zsh() {
    # Install zplug if it doesn't yet exist.
    if [ ! -d $HOME/.zplug ]; then
        git clone https://github.com/zplug/zplug $HOME/.zplug
    fi

    # Link zsh config and theme.
    ln -sf $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc
}

function install_brew() {
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

function setup_nvim() {
    install_brew
    brew list nvim &> /dev/null || brew install nvim

    # Link configuration.
    rm -rf "$HOME/.config/nvim"
    ln -sf "$HOME/.dotfiles/nvim" "$HOME/.config/nvim"
}

function install_iterm2 () {
    install_brew
    brew list iterm2 &> /dev/null || brew install --cask iterm2
}

function install_mactex() {
    install_brew
    brew list mactex-no-gui &> /dev/null || brew install --cask mactex-no-gui
    eval "$(/usr/libexec/path_helper)"
}

function install_nerdfonts() {
    install_brew
    brew list font-hack-nerd-font &> /dev/null || brew tap homebrew/cask-fonts;\
        brew install font-hack-nerd-font
}

function install_haskell() {
    if ! command -v ghcup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    fi
}

function install_rust () {
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}

function main() {
    if [[ $# -lt 1 ]]; then
        echo "usage: $0 --[all, zsh, nvim, brew, iterm, other]"
    fi

    zsh=false
    nvim=false
    brew=false
    iterm=false
    other=false

    for i in "$@"; do
        case $i in
            -z|--zsh)
                zsh=true
                ;;
            -n|--nvim)
                nvim=true
                ;;
            -b|--brew)
                brew=true
                ;;
            -i|--iterm)
                iterm=true
                ;;
            -o|--other)
                other=true
                ;;
            -a|--all)
                zsh=true
                nvim=true
                brew=true
                iterm=true
                other=true
                ;;
        esac
    done

    if $zsh; then
        install_zsh
    fi

    if $nvim; then
        setup_nvim
    fi

    if $brew; then
        install_brew
    fi

    if $iterm; then
        install_iterm2
    fi

    if $other; then
        install_nerdfonts
        install_haskell
        install_rust
        install_mactex
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
