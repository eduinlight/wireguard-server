SHELL=/bin/bash

all: up

up: docker-up acl-up

down: acl-down docker-down

docker-up:
	@docker compose up -d

docker-down:
	@docker compose down

acl-up:
	@./acl-up.sh

acl-down:
	@./acl-down.sh
