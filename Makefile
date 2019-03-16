# Makefile for Docker Nginx PHP Composer MySQL

#include .env

#ifeq ($(NGINX_DEBUG),1)
#  NGINX_EXEC=nginx-debug
#else
#  NGINX_EXEC=nginx
#endif

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  docker-build        Force rebuild of Dockerfiles."
	@echo "  docker-start        Create and start containers"
	@echo "  docker-stop         Stop and clear all services"
	@echo "  logs                Follow log output"

docker-build:
	@docker-compose build

docker-start:
	docker-compose up -d

docker-stop:
	@docker-compose down

logs:
	@docker-compose logs -f
