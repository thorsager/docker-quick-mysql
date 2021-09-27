Quick-MySQL
===========
This is noting but a minor addition to the [official](https://hub.docker.com/_/mysql)
MySQL image. For quick and dirty configuration during development and testing

All this does is introduce a new `ENV` var called `MYSQL_DATABASES`. This var
works in almost the same way as `MYSQL_DATABASE` in that it ensures that the
databases named in it are created on db-init and that is it really!. It
handles a `,` separated list of databases, which are *all* created in the same
way, and in addition to, the database in `MYSQL_DATABASE` is. 

```bash
docker run 
 -e MYSQL_ROOT_PASSWORD=changeme \
 -e MYSQL_USER=joe \
 -e MYSQL_PASSWORD=dalton \
 -e MYSQL_DATABASES=development,staging \
 ghcr.io/thorsager/quick-mysql
```


Fast turn-around
----------------
To allow for fast turnaround the `truncate-all.sh` script have been added to the
image, this script will truncate all tables in all databases (created by using 
`MYSQL_DATABASES`) (or a subset) on the server. Specific table-names can be ignored,
when needed.
```bash
docker exec my-mysql truncate-all.sh 
```
Will truncate all tables in all databases, leaving schema untouched.

If ex. you are using [flyway](https://flywaydb.org/) to manage you schema, then you
might which to _skip_ truncating the  `flyway_history_schema` table. this can be
done as follows:
```bash
docker exec my-mysql truncate-all.sh -i flyway_history_schema
```


Contributed
-----------
- [some-mysql.sh](contrib/some-mysql.sh), a script that will make running a 
  mysql-server on your laptop very easy and convenient. _(Just copy the script to 
  some folder in you `PATH` make the thing executable, and you af off)_.

