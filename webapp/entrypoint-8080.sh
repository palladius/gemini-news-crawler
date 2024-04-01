#!/bin/bash

set -euo pipefail

RAILS_ENV=${1:-development}
DOCKER_VERSION="$(cat VERSION)"
IMAGE="geminews:v$DOCKER_VERSION"

echo "--------------------"
echo "RAILS_MASTER_KEY: $RAILS_MASTER_KEY"
echo "DATABASE_URL_PROD: $DATABASE_URL_PROD"
echo "DATABASE_URL_DEV: $DATABASE_URL_DEV"
echo "RAILS_ENV: $RAILS_ENV"
echo "IMAGE: $IMAGE"
echo "--------------------"

docker images | grep "geminews"

docker run -it -p 8080:8080 \
    -e RAILS_MASTER_KEY=$RAILS_MASTER_KEY \
    -e DATABASE_URL_PROD=$DATABASE_URL_PROD \
    -e DATABASE_URL_DEV=$DATABASE_URL_DEV \
    -e RAILS_ENV=$RAILS_ENV \
    "$IMAGE"
