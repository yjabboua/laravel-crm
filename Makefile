.DEFAULT_GOAL := help

help:
	@echo "Welcome to the project!"

up:
	docker-compose -f docker-compose.development.yml up -d

build:
	docker-compose -f docker-compose.development.yml build

down:
	docker-compose -f docker-compose.development.yml down

php:
	docker exec -it laravel_php bash

artisan:
	docker exec -it laravel_php php artisan $(cmd)

composer:
	docker exec -it laravel_php composer $(cmd)
