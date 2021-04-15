FROM mysql:latest
MAINTAINER MAINTAINER "Michael Thorsager <thorsager@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/thorsager/docker-quick-mysql"
COPY from-env.sh /docker-entrypoint-initdb.d/00_from-env.sh
