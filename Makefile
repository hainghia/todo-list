.PHONY: build-development
build-development: ## Build the development docker image.
	@if [ ! -f docker/development/.env ]; then \
		cp .env.sample docker/development/.env; \
	fi
	docker compose -f docker/development/docker-compose.yml build --no-cache

.PHONY: start-development
start-development: ## Start the development docker container.
	#cp .env.development docker/development/.env
	docker compose -f docker/development/docker-compose.yml up -d

.PHONY: stop-development
stop-development: ## Stop the development docker container.
	#rm -f docker/development/.env
	docker compose -f docker/development/docker-compose.yml down

.PHONY: build-production
build-production:
	@if [ ! -f docker/production/.env ]; then \
		cp .env.example docker/production/.env; \
	fi
	docker compose -f docker/production/docker-compose.yaml build --no-cache

.PHONY: start-production
start-production:
	@if [ ! -f docker/production/.env ]; then \
		cp .env.example docker/production/.env; \
	fi
	docker compose -f docker/production/docker-compose.yaml up -d

.PHONY: stop-production
stop-production:
	docker compose -f docker/production/docker-compose.yaml down
