#!/bin/bash

#########
# Copied from DHH vanilla 701 and redone WELL.
# Using proper variables.
# Set up on Cloud Build script:
# * _GCLOUD_REGION
# * _PROJECT_ID (needed)
# * _REGION         (redundant)
# * _MESSAGGIO_OCCASIONALE (for fun)
# TODO: export APP_NAME='puffintours'

set -euo pipefail

export APP_NAME='gemini-news-crawler'
# Note the dash is in Ricc project id...
SKAFFOLD_DEFAULT_REPO=europe-west1-docker.pkg.dev/palladius-genai/gemini-news-crawler/gemini-news-crawler
#SKAFFOLD_DEFAULT_REPO="europe-west1-docker.pkg.dev/$PROJECT_ID/${APP_NAME}/${APP_NAME}"
#SHORT_SHA=todo
#VERSION=$(cat VERSION)
export GIT_STATE="$(git rev-list -1 HEAD --abbrev-commit)"
export GIT_COMMIT_SHA="$(git rev-parse HEAD)" # big commit
export GIT_SHORT_SHA="${GIT_COMMIT_SHA:0:7}" # first 7 chars: Riccardo reproducing what CB does for me.
export APP_VERSION="$(cat VERSION)"

set -x

# echo '1. Vediamo che immagini DHH-iane ci siano (BEFORE)..'
# docker images | grep puffin

echo '2. Tagging and pushing..'
docker tag "$SKAFFOLD_DEFAULT_REPO:sha-$GIT_SHORT_SHA" "$SKAFFOLD_DEFAULT_REPO:v$APP_VERSION"
docker push "$SKAFFOLD_DEFAULT_REPO" --all-tags


# echo '3. Vediamo che immagini DHH-iane ci siano (AFTER)..'
# docker images | grep dhh
