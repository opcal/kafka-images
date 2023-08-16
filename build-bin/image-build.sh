#!/bin/bash

set -e

echo " "
echo " "
echo 'build kafka start'

echo "build kafka:${SCALA_VERSION}-${KAFKA_VERSION} start"

IMAGE_REPO="${CI_REGISTRY}/opcal/kafka"
IMAGE_TAGS=("${RELEASE_VERSION}")

if [ ${RELEASE_VERSION} != 'SNAPSHOT' ]; then
    FULL_MINOR="$(echo ${RELEASE_VERSION} | cut -d '.' -f 1).$(echo ${RELEASE_VERSION} | cut -d '.' -f 2)"
    IMAGE_TAGS=(${IMAGE_TAGS[@]} "${FULL_MINOR}")
fi

BUILD_TAGS=""
for itag in "${IMAGE_TAGS[@]}"
do
  BUILD_TAGS=" ${BUILD_TAGS} -t ${IMAGE_REPO}:${itag} "
done

docker buildx build \
    --build-arg scala_version=${SCALA_VERSION} \
    --build-arg kafka_version=${KAFKA_VERSION} \
    --push \
    ${BUILD_TAGS} \
    -f ${PROJECT_DIR}/Dockerfile . --no-cache

# docker push ${CI_REGISTRY}/opcal/kafka:${RELEASE_VERSION}

echo "build kafka:${SCALA_VERSION}-${KAFKA_VERSION} finished"

echo 'build kafka finished'
echo " "
echo " "