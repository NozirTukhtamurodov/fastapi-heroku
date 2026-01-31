APP_NAME := fastapi-app
IMAGE_NAME := fastapi-app:latest
CONTAINER_NAME := fastapi-app-container
PORT := 8000
DOCKERFILE := Dockerfile

.PHONY: help build run stop start restart kill logs shell clean rebuild status

help:
	@echo "Available commands:"
	@echo "  make build     - Build Docker image"
	@echo "  make run       - Run container (always new)"
	@echo "  make start     - Smart start (build + run if missing)"
	@echo "  make stop      - Stop container"
	@echo "  make restart   - Restart container"
	@echo "  make kill      - Kill container"
	@echo "  make logs      - Tail logs"
	@echo "  make shell     - Shell into container"
	@echo "  make status    - Show container status"
	@echo "  make clean     - Remove container and image"
	@echo "  make rebuild   - Clean + build + run"

build:
	docker build -t $(IMAGE_NAME) -f $(DOCKERFILE) .

run:
	docker run -d \
		--name $(CONTAINER_NAME) \
		-p $(PORT):8000 \
		--restart unless-stopped \
		$(IMAGE_NAME)

start:
	@if ! docker image inspect $(IMAGE_NAME) > /dev/null 2>&1; then \
		echo "Image not found. Building image..."; \
		make build; \
	fi
	@if ! docker ps -a --format '{{.Names}}' | grep -w $(CONTAINER_NAME) > /dev/null; then \
		echo "Container not found. Creating container..."; \
		make run; \
	elif ! docker ps --format '{{.Names}}' | grep -w $(CONTAINER_NAME) > /dev/null; then \
		echo "Container exists but stopped. Starting container..."; \
		docker start $(CONTAINER_NAME); \
	else \
		echo "Container already running."; \
	fi

stop:
	docker stop $(CONTAINER_NAME)

restart:
	make stop || true
	make start

kill:
	docker kill $(CONTAINER_NAME)

logs:
	docker logs -f $(CONTAINER_NAME)

shell:
	docker exec -it $(CONTAINER_NAME) /bin/sh

status:
	docker ps -a | grep $(CONTAINER_NAME) || true

clean:
	-docker rm -f $(CONTAINER_NAME)
	-docker rmi -f $(IMAGE_NAME)

rebuild: clean build run
