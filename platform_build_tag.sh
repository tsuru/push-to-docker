#!/bin/bash

function build_and_tag {
	PLATFORM=$1
	DOCKER_TAG=$2
	if [ -z $DOCKER_TAG ]; then
		DOCKER_TAG="latest"
	fi
	echo "Building platform and tagged as tsuru/${PLATFORM}:${DOCKER_TAG}"
	pushd ${PLATFORM}
	echo docker build -t tsuru/${PLATFORM}:${DOCKER_TAG} .
	echo docker push tsuru/${PLATFORM}:${DOCKER_TAG}
	popd
}

cat > ~/.dockercfg <<EOF
{
  "https://index.docker.io/v1/": {
    "auth": "${HUB_AUTH}"
  }
}
EOF

for PLATFORM in ${PLATFORMS}
do
	if [ -n "$TRAVIS_TAG" ] && [[ $TRAVIS_TAG =~ ${PLATFORM}-([0-9.]+) ]]; then
		TAG=${BASH_REMATCH[1]}
		build_and_tag "${PLATFORM}"
		build_and_tag "${PLATFORM}" "${TAG}"
	else
		build_and_tag "${PLATFORM}"
	fi
done
