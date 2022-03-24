FROM mysql:8

COPY .docker/mysql/conf.d/my.cnf /etc/mysql/conf.d/my.cnf

COPY .docker/mysql/scripts/*.sql /docker-entrypoint-initdb.d/
