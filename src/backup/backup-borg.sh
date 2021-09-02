#!/bin/bash

## Example encryption=none and ~/.ssh/id_rsa borgbackup script

source .env 2>/dev/null

if [[ -z $BORG_REPO ]]
then
    echo "BORG_REPO is unset or empty, exiting..."
    exit 1
fi


service="git-registry"
name="$service-borgbackup-$1"
borgbackup_volume="git-registry_git-registry-borgbackup-volume"


docker-compose-run() {
    docker-compose run --rm --no-deps --name "$name" \
        -e "BORG_REPO=$BORG_REPO" \
        -e "BORG_BASE_DIR=/borgbackup" \
        -e "BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes" \
        -e "BORG_RELOCATED_REPO_ACCESS_IS_OK=yes" \
        -v "$borgbackup_volume:/borgbackup" \
        -v "$HOME/.ssh/id_rsa:/root/.ssh/id_rsa" \
        -v "$HOME/.ssh/known_hosts:/root/.ssh/known_hosts" \
        -w "/home/git/src" \
        "$service" \
        "$@"
}

if [[ $1 == "init" ]]; then
    borg init --encryption=none

elif [[ $1 == "create" ]]; then
    docker volume create "$borgbackup_volume"
    docker-compose-run \
        bash -c '
            borg create                                 \
               --stats                                  \
               --info                                   \
               --noatime                                \
               --noctime                                \
               --nobsdflags                             \
               --exclude-caches                         \
               --one-file-system                        \
               "::git-repository{now}" .

            borg prune --list --keep-daily=7 --keep-weekly=4 --keep-monthly=6
        '

elif [[ $1 == "restore" ]]; then
    docker-compose-run \
        bash -c '
            shopt -s dotglob
            rm -r /home/git/src/*
            borg extract ::$(borg list --last 1 --short)
        '


elif [[ $1 == "shell" ]]; then
    printf "\n%s\n" "Run borg command, e.g.:"
    printf "%s\n"   "> borg list"
    printf "%s\n\n" "> borg extract ::git-repository2011-03-21T09:27:30"
    docker-compose-run bash


else
    echo "usage: backup-borg.sh init"
    echo "usage: backup-borg.sh create"
    echo "usage: backup-borg.sh restore"
    echo "usage: backup-borg.sh shell"
fi


