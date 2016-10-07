# Push to Docker Hub
Bash script to push versioned images to docker hub

The script will push the image if the env TRAVIS_GO_VERSION matches the GO_FOR_RELEASE.

# Behavior

If on master => pushes to latest.

If it's a tag in the format v1.2.3 => pushes to v1.2.3 and v1

If it's a tag in the format v1.2.3-rc => pushes to v1.2.3-rc

# Configuration

`IMAGE_NAME`: image name, in the format, `repo/name`, to be used when pushing the image.
