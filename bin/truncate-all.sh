#!/usr/bin/env bash
usage() {
  echo "USAGE: $(basename "$0") [-d <databases>] [-i <tables>] [-r <databases>] [-s]" 1>&2
  echo "" 1>&2
  echo "   Arguments:" 1>&2
  echo "     -d <databases>           Databases (coma separated list) of which to truncate all tables," 1>&2
  echo "                              defaults to MYSQL_DATABASES ($MYSQL_DATABASES)" 1>&2
  echo "     -r <databases>           Databases (coma separated list) of which to drop all tables" 1>&2
  echo "     -i <tables>              Names of tables (coma separated list) which NOT to truncate" 1>&2
  echo "     -s                       Silent, no output." 1>&2
}

# Default
TRUNCATE_DATABASES=$MYSQL_DATABASES

while getopts ":hsr:d:i:" opt; do
  case ${opt} in
  i)
    IGNORING=${OPTARG}
    ;;
  d)
    TRUNCATE_DATABASES=${OPTARG}
    ;;
  r)
    DROP_DATABASES=${OPTARG}
    ;;
  s)
    SILENT=true
    ;;
  h)
    usage
    exit 1
    ;;
  \?)
    echo "Invalid option: $OPTARG" 1>&2
    exit 1
    ;;
  :)
    echo "Invalid option: $OPTARG requires an argument" 1>&2
    exit 1
    ;;
  esac
done

# shellcheck disable=SC2001
TRUNCATE_DATABASES=$(echo "$TRUNCATE_DATABASES" | sed "s/,/','/g")
# shellcheck disable=SC2001
DROP_DATABASES=$(echo "$DROP_DATABASES" | sed "s/,/','/g")
# shellcheck disable=SC2001
IGNORING=$(echo "$IGNORING" | sed "s/,/','/g")

if [ -n "$TRUNCATE_DATABASES" ]; then
  if [ -z "$SILENT" ]; then
    echo "Truncating tables in '$TRUNCATE_DATABASES'" 1>&2
    if [ -n "$IGNORING" ]; then
      echo "- Ignoring tables: '$IGNORING'" 1>&2
    fi
  fi
  TRUNCATE_SQL="SELECT CONCAT('TRUNCATE TABLE ',table_schema,'.',table_name,';') FROM information_schema.TABLES WHERE TABLE_SCHEMA IN ('$TRUNCATE_DATABASES') AND TABLE_NAME NOT IN ('$IGNORING');"
fi

if [ -n "$DROP_DATABASES" ]; then
  if [ -z "$SILENT" ]; then
    echo "Dropping tables in '$DROP_DATABASES'" 1>&2
  fi
  DROP_SQL="SELECT CONCAT('DROP TABLE ',table_schema,'.',table_name,';') FROM information_schema.TABLES WHERE TABLE_SCHEMA IN ('$DROP_DATABASES');"
fi

echo "SQL: $TRUNCATE_SQL $DROP_SQL"
MYSQL_PWD=${MYSQL_ROOT_PASSWORD} \
  mysql -sN -e "SET FOREIGN_KEY_CHECKS=0; $(MYSQL_PWD=${MYSQL_ROOT_PASSWORD} mysql -sN -e "$TRUNCATE_SQL $DROP_SQL") SET FOREIGN_KEY_CHECKS=1;"
