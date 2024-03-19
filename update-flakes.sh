#!/usr/bin/env sh

# TODO args
find . -type d |
    sed 1d |
    grep -Ev '^\./\.git' |
    xargs -d '\n' -I{} nix flake update "{}"
