# Makefile for Docker Nginx PHP Composer MySQL

include .env

ifeq ($(NGINX_DEBUG),1)
  NGINX_EXEC=nginx-debug
else
  NGINX_EXEC=nginx
endif

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  docker-start        Create and start containers"
	@echo "  docker-stop         Stop and clear all services"
	@echo "  docker-destroy      remove volumes and clean directoriesq"
	@echo "  cert-only           Request additional certs"
	@echo "  cert-help          certbot help"
	@echo "  logs                Follow log output"
	@echo "  mysql-cli           Access mysql CLI"
	@echo "  mysql-dump          Create backup of all databases"
	@echo "  mysql-restore       Restore backup of all databases"
	@echo "  nginx-test          Test nginx config"
	@echo "  nginx-reload        Reload nginx"

clean:
	@sudo rm -Rf data/web/*
	@sudo rm -Rf data/nginx/*
	@sudo rm -Rf data/db/mysql/*
	@sudo rm -Rf data/db/dumps/*

docker-build:
	@docker-compose build

docker-start:
	docker-compose up -d

docker-stop:
	@docker-compose down

docker-destroy:
	@docker-compose down -v
	@make clean

docker-ps:
	@docker-compose ps

logs:
	@docker-compose logs -f

mysql-cli:
	@docker exec -it $(shell docker-compose ps -q mysqldb) mysql -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)"

mysql-dump:
	@mkdir -p $(MYSQL_DUMPS_DIR)
	@docker exec $(shell docker-compose ps -q mysqldb) mysqldump --all-databases -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" > data/db/dumps/db.sql 2>/dev/null
	@make resetOwner

mysql-restore:
	@docker exec -i $(shell docker-compose ps -q mysqldb) mysql -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" < data/db/dumps/db.sql 2>/dev/null

cert-help:
	@scripts/cert-r53.sh --help

cert-only:
	@scripts/cert-r53.sh certonly

nginx-shell:
	@docker exec -it nginx /bin/bash

nginx-test:
	@docker-compose exec nginx $(NGINX_EXEC) -t

nginx-reload:
	docker-compose exec nginx $(NGINX_EXEC) -s reload

in-shell:
	@docker exec -it invoiceninja /bin/sh

resetOwner:
	@$(shell sudo chown -Rf $($USER):$(shell id -g -n $(USER)) $(MYSQL_DUMPS_DIR) "$(shell pwd)/le" 2> /dev/null)

.PHONY: clean
