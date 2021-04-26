#!/usr/bin/env bash
if [ ! -z "$MYSQL_DATABASES" ]; then 
	readarray -td, a <<< "$MYSQL_DATABASES"

	mysql_note "********* quck-init ***********"
	for db in "${a[@]}"; do 
		db_name=${db//[$'\n' ]/}
		mysql_note "Create and grant for $MYSQL_USER on $db_name"
		docker_process_sql <<-EOSQL
		CREATE DATABASE $db_name; 
		GRANT ALL ON $db_name.* TO '$MYSQL_USER'@'${MYSQL_HOST:-%}';
		EOSQL
	done
	mysql_note "*******************************"
fi

