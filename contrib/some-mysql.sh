#!/usr/bin/env bash
IMAGE=ghcr.io/thorsager/quick-mysql
IMAGE_TAG=8
DATABASES=devel
USER_NAME=devel
USER_PASSWORD=devel
NAME="some-mysql"
ROOT_PASSWORD=changeme
PORT=3306


usage() {
	echo "USAGE: $(basename $0) [-k] [-l] [-m <mysql-tag>] [-d <databases>] [-u <user> [-p <password>] [-n <name>] [-r <root-password>]" 1>&2
	echo "" 1>&2
	echo "   Arguments:" 1>&2
	echo "     -l                 tail the log of the container withe name definced by -n" 1>&2
	echo "     -k                 kill any running container with name definded by -n" 1>&2
	echo "     -m <mysql-tag>     image tag for the mysql server, supported 5 and 8 (default: ${IMAGE_TAG})" 1>&2
	echo "     -d <databases>     comman seperated list of databases to be created (default: '${DATABASES}')" 1>&2
	echo "     -u <user>          name of the user to be created, with GRANT ALL on all databases (default: ${USER_NAME})" 1>&2
	echo "     -p <password>      password for created user (default: ${USER_PASSWORD})" 1>&2
	echo "     -n <name>          name of the container running mysql (default: ${NAME})" 1>&2
	echo "     -r <root-password> password to be set for root user (default: ${ROOT_PASSWORD})" 1>&2
	echo "     -P <port>          Port on which to bind (default: ${PORT})" 1>&2
}

while getopts "hklm:d:u:p:n:r:P" opt; do
	case ${opt} in
		m)
			IMAGE_TAG=${OPTARG}
			;;
		d)
			DATABASES=${OPTARG}
			;;
		u)
			USER_NAME=${OPTARG}
			;;
	  n)
	    NAME=${OPTARG}
	    ;;
		p)
			USER_PASSWORD=${OPTARG}
			;;
	  P)
	    PORT=${OPTARG}
	    ;;
		r)
			ROOT_PASSWORD=${OPTARG}
			;;
		k)
			KILL=true
			;;
		l)
			LOGS=true
			;;
		h)
			usage
			exit 1
			;;
	    \? )
      		echo "Invalid option: $OPTARG" 1>&2
			exit 1
      		;;
    	: )
      		echo "Invalid option: $OPTARG requires an argument" 1>&2
			exit 1
			;;
	esac
done

if [ -n "${KILL}" ]; then
	echo "Killing ${NAME}" 1>&2
	docker kill "${NAME}"
	exit
fi

if [ -n "${LOGS}" ]; then
	docker logs --tail 100 --follow "${NAME}"
	exit
fi

echo "Starting $NAME (from: $IMAGE:$IMAGE_TAG)" 1>&2
docker run --rm -p "$PORT:3306" --name "${NAME}" \
	   -e MYSQL_ROOT_PASSWORD="${ROOT_PASSWORD}" \
	   -e MYSQL_USER="${USER_NAME}" \
	   -e MYSQL_PASSWORD="${USER_PASSWORD}" \
	   -e MYSQL_DATABASES="${DATABASES}" \
	   -d "$IMAGE:$IMAGE_TAG"