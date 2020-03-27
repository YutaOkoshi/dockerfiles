.PHONY: all

DOCKER  ?= docker
DOCKER_COMPOSE  ?= docker-compose
DOCKER_HOST_IP ?= 127.0.0.1
OPEN_CMD ?= open
GROUP ?= all
PROJECT_NAME ?= xxxx_project

build: docker-build
up: docker-up httpd phpfpm
kill: docker-kill
migrate: db-migrate db-seed
clean: docker-kill docker-clean
test: test-setup test-run

docker-build:	##@development build images
	$(DOCKER_COMPOSE) build --force-rm
docker-up:		##@development start stack
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) up -d
docker-kill:	##@development kill process
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) kill
docker-clean:	 ##@development remove all containers in stack
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) rm -fv --all
	$(DOCKER_COMPOSE) down --rmi local --remove-orphans


db-migrate:	##@development db migrate
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -web /var/app/bin/cake migrations migrate
db-seed:	##@development db seeding
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -web /var/app/bin/cake migrations seed

test-setup:	##@development provisioning
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -web /var/app/bin/unittest/setup.sh
test-run:		##@development start stack
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -web /var/app/bin/unittest/unit_test.sh


web-bash:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -web bash
db-bash:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -db bash

composer-install:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -web sh -c "cd /var/app && /usr/bin/composer install --no-interaction"
httpd:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -web httpd
phpfpm:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) exec -web php-fpm

localci:
	circleci local execute

local-setup-all: clean build up composer-install migrate test-setup
