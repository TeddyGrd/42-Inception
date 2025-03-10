COMPOSE_FILE = ./srcs/docker-compose.yml

all: up

up:
	@docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@docker compose -f $(COMPOSE_FILE) down

re: fclean all

clean:
	@echo " -> Nettoyage des conteneurs, images et réseaux inutiles..."
	@docker container prune -f 2>/dev/null || true
	@docker image prune -f 2>/dev/null || true
	@docker network prune -f 2>/dev/null || true

fclean: down
	@echo " -> Suppression de TOUT, + volume..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker system prune -af --volumes 2>/dev/null || true

build:
	@echo " -> Reconstruction des conteneurs sans les lancer..."
	@docker compose -f $(COMPOSE_FILE) build

.PHONY: all up down re clean fclean build
