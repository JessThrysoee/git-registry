.PHONY: missing-target host-keygen up run-shell exec-shell add-public-key

missing-target:
	@exit 1

host-keygen:
	docker compose run --rm git-registry ssh-keygen -A -f /git-registry

up:
	docker compose up -d

run-shell:
	docker compose run --rm git-registry bash

exec-shell:
	docker compose exec git-registry bash

# example: make add-public-key PUBLIC_KEY_FILE=~/.ssh/id_rsa.pub
add-public-key:
	docker compose exec git-registry /add-public-key.sh "$$(cat $(PUBLIC_KEY_FILE))"

