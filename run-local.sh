#!/bin/bash
TAG="bazel-intellij-compatibility"
mkdir -p {results,bazelisk-cache}

docker build -t $TAG .
docker run \
  --interactive \
  --tty \
  --rm \
  --env=XDG_CACHE_HOME=/bazelisk-cache \
  --volume=$(pwd)/results:/results \
  --volume=$(pwd)/bazelisk-cache:/bazelisk-cache \
  $TAG

