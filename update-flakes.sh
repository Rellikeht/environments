#!/usr/bin/env sh

# TODO args
find . -maxdepth 1 -mindepth 1 -type d |
    grep -Ev '^\./\.git|pure-direnv' |
    xargs -d '\n' -I{} sh -c 'nix flake update "{}"'
