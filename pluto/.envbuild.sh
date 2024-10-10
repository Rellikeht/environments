#!/usr/bin/env sh
# export DIRENV_LOG_FORMAT=''
nix develop 'gitlab:Rellikeht/environments#pluto' \
    -c direnv dump >.envrc.cache
