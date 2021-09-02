#!/bin/bash -e

if [[ $# -ne 1 ]]; then
    printf "%s\n%s\n" \
        "usage  : add-public-key.sh PUBLIC_KEY" \
        "example: add-public-key.sh \"\$(cat ~/.ssh/id_rsa.pub)\""
    exit 1
fi

PUBLIC_KEY="$1"

if ! printf "%s" "$PUBLIC_KEY" | ssh-keygen -lf - >/dev/null
then
    printf "%s\nIS NOT A PUBLIC KEY.\nFAILED\n" "$PUBLIC_KEY" >&2
    exit 1
fi


GIT_DIR="/git-registry/etc/ssh/git"
AUTHORIZED_KEYS_FILE="$GIT_DIR/authorized_keys"

mkdir -p "$GIT_DIR"
printf "\n%s\n" "$PUBLIC_KEY" >> "$AUTHORIZED_KEYS_FILE"

chown -R git:git "$GIT_DIR" 
chmod 755 "$GIT_DIR"
chmod 644 "$AUTHORIZED_KEYS_FILE"

echo "DONE"

