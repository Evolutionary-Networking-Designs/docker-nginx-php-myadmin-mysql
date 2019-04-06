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
	@docker exec -it mysql mysql -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)"

mysql-dump:
	mkdir -p ./data/db/dumps
	docker exec mysql mysqldump --all-databases -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" | sudo cat > ./data/db/dumps/db.sql
	sudo chown -R mysql:mysql ./data/db/dumps/db.sql

mysql-restore:
	docker cp ./data/db/dumps/db.sql mysql:/export/db.sql
	docker exec mysql mysql -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" < ./data/db/dumps/db.sql

mysql-reset:
	sudo rm -rf /opt/docker-data/openemr/mysql
	sudo mkdir /opt/docker-data/openemr/mysql
	sudo chown -R mysql:mysql /opt/docker-data/openemr/mysql

mysql-shell:
	docker exec -it mysql /bin/bash

mysql-eshell:
	docker run --rm -it --name mysql -env-file .env -v mysql-data:/var/lib/mysql meredithk/mysql /bin/bash

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

.PHONY: clean
