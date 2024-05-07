.PHONY: run
run: run-go

run-go:
	@echo "Starting Go API..."
	@go run cmd/api/main.go &

#
# Development
# ------------------------------------------------------------------------------

build:
	@echo "\nStarting build...\n"
	docker compose build

rebuild:
	@echo "\nForcing Rebuild...\n"
	@docker compose build --no-cache --force-rm --pull

up:
	@echo "\nStarting container...\n"
	docker compose up -d --force-recreate

stop:
	@echo "\nStoping container...\n"
	docker compose stop -t 0

down:
	@echo "\nStoping container...\n"
	docker compose down -v --remove-orphans --rmi all -t 0

top:
	docker compose top

ps:
	docker compose ps

log:
	docker compose logs -f

events:
	docker compose events

pause:
	docker compose pause

unpause:
	docker compose unpause

exec:
	@echo "\nEntering container...\n"
	docker exec -ti ${CONTAINER} sh

dang:
	@echo "\nStarting dangling removal\n"
	docker rmi $$(docker images -q -f dangling=true)

prune:
	docker system prune -af --volumes

remove:
	docker rm $$(docker ps -a -q) -f
