VERSION=$(shell cat VERSION)
GOFLAGS=ldflags "-X main.Version=$(VERSION)"
PROJECT=waldirborbajr/kollekt


.PHONY: help
run: help

run-go:
	@echo "Starting Go API..."
	go run cmd/api/main.go

help:  ## 💬 This help message :)
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


#
# Development
# ------------------------------------------------------------------------------

image:
	@docker build . -t $(PROJECT):$(VERSION)

build: ## 🔨 Docker build
	@echo "\nStarting build...\n"
	docker compose build

rebuild: ## Docker force build
	@echo "\nForcing Rebuild...\n"
	docker compose build --no-cache --force-rm --pull

up: ## Docker start container
	@echo "\nStarting container...\n"
	docker compose up -d --force-recreate

stop: ## Docker stop container
	@echo "\nStoping container...\n"
	docker compose stop -t 0

down: ## Docker down removing orphans
	@echo "\nStoping container...\n"
	docker compose down -v --remove-orphans --rmi all -t 0

top: ## Docker top command
	docker compose top

ps: ## Docker display process
	docker compose ps

log: ## Docker container logs
	docker compose logs -f

events: ## Docker display events
	docker compose events

pause: ## Docker pause container
	docker compose pause

unpause: ## Docker unpause container
	docker compose unpause

exec: ## Docker exec container interactive mode
	@echo "\nEntering container...\n"
	docker exec -ti ${CONTAINER} sh

dang: ## Docker remove all dang images
	@echo "\nStarting dangling removal\n"
	docker rmi $$(docker images -q -f dangling=true)

prune: ## * * * DANGER * * * Remove everthing (prune all)
	docker system prune -af --volumes

remove: ## Docker remove forcing
	docker rm $$(docker ps -a -q) -f
