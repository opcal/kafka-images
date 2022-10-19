#!/bin/sh

set -e

echo " "
echo " "
echo 'build kafka start'

echo "build kafka:${SCALA_VERSION}-${KAFKA_VERSION} start"

docker build \
    --build-arg scala_version=${SCALA_VERSION} \
    --build-arg kafka_version=${KAFKA_VERSION} \
    -t kafka:${SCALA_VERSION}-${KAFKA_VERSION} \
    -f ${PROJECT_DIR}/Dockerfile . --no-cache
docker image tag kafka:${SCALA_VERSION}-${KAFKA_VERSION} ${CI_REGISTRY}/opcal/kafka:${RELEASE_VERSION}
docker push ${CI_REGISTRY}/opcal/kafka:${RELEASE_VERSION}

echo "build kafka:${SCALA_VERSION}-${KAFKA_VERSION} finished"

echo 'build kafka finished'
echo " "
echo " "