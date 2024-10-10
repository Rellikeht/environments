#!/usr/bin/env sh
# export DIRENV_LOG_FORMAT=''
nix develop 'gitlab:Rellikeht/environments#sysops' \
    -c direnv dump >.envrc.cache
