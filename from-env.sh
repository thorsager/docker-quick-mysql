#!/usr/bin/env bash
if [ ! -z "$MYSQL_DATABASES" ]; then 
	readarray -td, a <<< "$MYSQL_DATABASES"

	for db in "${a[@]}"; do 
		db_name=${db//[$'\n' ]/}
		echo "Create and grant for $db_name"
		"${mysql[@]}" <<-EOSQL
				CREATE DATABASE $db_name;
				GRANT ALL ON $db_name.* TO '$MYSQL_USER'@'${MYSQL_HOST:-%}';
		EOSQL
	done
fi

