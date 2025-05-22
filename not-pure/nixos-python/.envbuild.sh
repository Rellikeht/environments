#!/usr/bin/env sh

__OS="$(awk -F'=' '/^NAME=/ {print $2}' /etc/os-release 2>/dev/null)"
__NIX_FILE="https://gitlab.com/Rellikeht/environments/-/raw/main/pure-direnv/nixos-python/nixos.shell.nix"
if [ "$__OS" = "NixOS" ]; then
    if [ ! -f "nixos.shell.nix" ]; then
        wget -O nixos.shell.nix "$__NIX_FILE"
    fi
fi

# pip install --upgrade pip
uv pip install -U -r requirements.txt

# export DIRENV_LOG_FORMAT=''
direnv dump >.envrc.cache
