Quick-MySQL
===========
This is noting but a minor addition to the [official](https://hub.docker.com/_/mysql)
MySQL image. For quick and dirty configuration during development and testing

All this does is introduce a new `ENV` var called `MYSQL_DATABASES`. This var
works in almost the same way as `MYSQL_DATABASE` in that it ensures that the
databases named in it are created on db-init and that is it really!. It
handles a `,` separated list of databases, which are *all* created in the same
way, and in addition to, the database in `MYSQL_DATABASE` is. 

```
docker run 
 -e MYSQL_ROOT_MASSWORD=changeme \
 -e MYSQL_USER=joe \
 -e MYSQL_PASSWORD=dalton \
 -e MYSQL_DATABASES=development,staging \
 ghcr.io/thorsager/quick-mysql
```

Contributed
-----------
- [some-mysql.sh](contrib/some-mysql.sh), a script that will make running a 
  mysql-server on your laptop very easy and convenient. _(Just copy the script to 
  some folder in you `PATH` make the thing executable, and you af off)_.

