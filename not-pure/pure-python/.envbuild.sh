#!/usr/bin/env sh

# pip install -U -r requirements.txt
uv pip install -U -r requirements.txt
# export DIRENV_LOG_FORMAT=''
direnv dump >.envrc.cache
