#!/usr/bin/env bash
exec docker run --rm \
		   -p 3306:3306 \
		   -e MYSQL_ROOT_PASSWORD=123 \
		   -e MYSQL_USER=joe \
		   -e MYSQL_PASSWORD=dalton \
		   -e MYSQL_DATABASES=d1,d2,d3 \
		   quick-mysql
