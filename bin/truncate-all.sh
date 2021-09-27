#!/usr/bin/env bash
usage() {
  echo "USAGE: $(basename "$0") [-d <databases>] [-i <tables>] [-s]" 1>&2
  echo "" 1>&2
  echo "   Arguments:" 1>&2
  echo "     -d <database>            Databases (coma separated list) of which to truncate all tables," 1>&2
  echo "                              defaults to MYSQL_DATABASES ($MYSQL_DATABASES)" 1>&2
  echo "     -i <tables>              Names of tables (coma separated list) which NOT to truncate" 1>&2
  echo "     -s                       Silent, no output." 1>&2
}

# Default
DATABASES=$MYSQL_DATABASES

while getopts ":hsd:i:" opt; do
  case ${opt} in
  i)
    IGNORING=${OPTARG}
    ;;
  d)
    DATABASES=${OPTARG}
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
DATABASES=$(echo "$DATABASES" | sed "s/,/','/g")
# shellcheck disable=SC2001
IGNORING=$(echo "$IGNORING" | sed "s/,/','/g")

if [ -z "${SILENT}" ]; then
  echo "Truncating tables in '$DATABASES'" 1>&2
  if [ -n "$IGNORING" ]; then
    echo "Ignoring: '$IGNORING'" 1>&2
  fi
fi

SQL="SELECT CONCAT('TRUNCATE TABLE ',table_schema,'.',table_name,';') FROM information_schema.TABLES
WHERE TABLE_SCHEMA IN ('$DATABASES') AND TABLE_NAME NOT IN ('$IGNORING');"
MYSQL_PWD=${MYSQL_ROOT_PASSWORD} \
  mysql -sN -e "SET FOREIGN_KEY_CHECKS=0; $(MYSQL_PWD=${MYSQL_ROOT_PASSWORD} mysql -sN -e "$SQL") SET FOREIGN_KEY_CHECKS=1;"
