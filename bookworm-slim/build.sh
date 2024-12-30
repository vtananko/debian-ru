#!/bin/bash

GHCR_PAT_FILE=~/prj/docker/github.pat
GHCR_USERNAME=vtananko
REPO_NAME="debian-ru"

if [ "$1" == "ghcr" ]; then
	TAG_PREFIX="ghcr.io/$GHCR_USERNAME/$REPO_NAME:bookworm"
else
	TAG_PREFIX="$REPO_NAME:bookworm"
fi

DT=`date +%Y%m%d`
TAG_SUFFIX="slim"
TAG_NAME="$TAG_PREFIX-$DT-$TAG_SUFFIX"

#docker image inspect -f '{{ .Id }}' $TAG_NAME > /dev/null 2>&1
#if (( $? == 0 )) ; then
#	echo "Docker image $TAG_NAME already exists!"
#	exit 1
#fi

docker build -t $TAG_NAME \
	--build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
	--build-arg BUILD_VERSION=$TAG_NAME \
	--build-arg VCS_REF=$(git rev-parse --short HEAD) \
	.
(( $? == 0 )) || exit 2

VERSION=`docker run -t --rm $TAG_NAME cat /etc/debian_version | tr -d '\r'`
MAJOR_VERSION="$(cut -d'.' -f1 <<<"$VERSION")"

docker tag $TAG_NAME $TAG_PREFIX-$TAG_SUFFIX
docker tag $TAG_NAME $TAG_PREFIX-$MAJOR_VERSION-$TAG_SUFFIX
docker tag $TAG_NAME $TAG_PREFIX-$VERSION-$TAG_SUFFIX

if [ "$1" == "ghcr" ]; then
	echo "GHCR start..."
	if [ ! -f $GHCR_PAT_FILE ]; then
		echo "Not have GitHub Personal Access Token file. Exit."
		exit 3
	fi
	#echo "GHCR cat PAT file..."
	#GHCR_PAT=`cat $GHCR_PAT_FILE`
	echo "Docker login to ghcr.io..."
	cat $GHCR_PAT_FILE | docker login ghcr.io -u $GHCR_USERNAME --password-stdin
	echo "Docker push to ghcr.io..."
	docker push -a ghcr.io/$GHCR_USERNAME/$REPO_NAME
fi
