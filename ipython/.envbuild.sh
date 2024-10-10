#!/usr/bin/env sh
# export DIRENV_LOG_FORMAT=''
nix develop 'gitlab:Rellikeht/environments#ipython' \
    -c direnv dump >.envrc.cache
