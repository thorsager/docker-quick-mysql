FROM mysql:8
MAINTAINER MAINTAINER "Michael Thorsager <thorsager@gmail.com>"
COPY from-env.sh /docker-entrypoint-initdb.d/
