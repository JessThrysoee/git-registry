#!/bin/bash

[[ -e $HOME/src/.env ]] && source "$HOME/src/.env"

GIT_REGISTRY_HOST="${GIT_REGISTRY_HOST:-localhost}"
GIT_REGISTRY_PORT="${GIT_REGISTRY_PORT-2222}"

if [[ -n $GIT_REGISTRY_PORT ]]; then
    : "${GIT_REGISTRY_AUTHORITY:=[git@${GIT_REGISTRY_HOST}:${GIT_REGISTRY_PORT}]}"
else
    : "${GIT_REGISTRY_AUTHORITY:=git@${GIT_REGISTRY_HOST}}"
fi

