FROM mysql:latest
MAINTAINER MAINTAINER "Michael Thorsager <thorsager@gmail.com>"
COPY from-env.sh /docker-entrypoint-initdb.d/00_from-env.sh
