#!/bin/bash

# Only build platforms and push to dockerhub when commiting to master branch
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH"
echo "TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST"
echo "PR=$PR"
if [[ "${TRAVIS_BRANCH}" != "master" || "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
	echo "This branch isn't master so we wont build/push images to dockerhub"
	exit 0;
fi

function build_and_tag {
	PLATFORM=$1
	DOCKER_TAG=$2
	if [ -z $DOCKER_TAG ]; then
		DOCKER_TAG="latest"
	fi
	echo "Building platform and tagged as tsuru/${PLATFORM}:${DOCKER_TAG}"
	pushd ${PLATFORM}
	docker build -t tsuru/${PLATFORM}:${DOCKER_TAG} .
	docker push tsuru/${PLATFORM}:${DOCKER_TAG}
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
