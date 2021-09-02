#!/bin/bash

service="git-registry"
name="$service-backup-$1"

docker-compose-run() {
    docker-compose run --rm --no-deps --name "$name" -v "$backup_tar_gz:/backup.tar.gz" "$service" "$@"
}

if [[ $1 == "create" ]]; then

    backup_tar_gz="$(mktemp)"
    trap 'rm -f "$backup_tar_gz"' exit

    docker-compose stop "$service" 

    docker-compose-run bash -c '
        tar -czf /backup.tar.gz -C /home/git/ src
    '

    docker-compose start "$service" 

    mv "$backup_tar_gz" "${2:-/tmp/${service}-backup-$(date +%Y%m%dT%H%M%S).tar.gz}"


elif [[ $1 == "restore" ]]; then

    backup_tar_gz="$2"

    docker-compose stop "$service" 

    docker-compose-run bash -c '
        shopt -s dotglob
        rm -r /home/git/src/*
        tar -xzf /backup.tar.gz -C /home/git/
        chown -R git:git /home/git/src
    '

    docker-compose start "$service" 


else
    echo "usage: backup.sh create  [DST_TAR_GZ]"
    echo "usage: backup.sh restore <SRC_TAR_GZ>"
fi

