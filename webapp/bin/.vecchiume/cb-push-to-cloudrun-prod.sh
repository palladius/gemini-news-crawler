#!/bin/bash

#####################################################################################################
# Since CB doesnt have access to a number of vars, I'm trying to add them as secret
# AND THEN retrieve them from CB. If it works locally, it should hopefully also work remotely
# As long as CB has access to those secrets (CB SA was enabled to read secrets).
#
# 2024-04-01 v1.0.3 Removed PORT, turns out its illegal
#
#####################################################################################################

export DEPLOY_VERSION='1.0.3'
#direnv allow "$(git rev-parse --show-toplevel)"
# if it fails no probs... yet

if [ -f .envrc ] ; then
  echo Looks like youre local since I see your envrc.
  . .envrc
else
  echo 'Riccardo NOT LOCAL probably in the Cloud'
fi

if [ -f /secretenvrc/gemini-news-crawler-envrc ] ; then
  echo Looks like youre on Cloud Run mounting an envrc directly form SM. You could be protecteder. # :)
  . /secretenvrc/gemini-news-crawler-envrc
else
  echo Riccardo NOT Secret in /secretenvrc/gemini-news-crawler-envrc
fi

set -euo pipefail

################################################
# ENV set
################################################
export GCLOUD_REGION="${GCLOUD_REGION:-europe-west1}"
export APP_NAME='gemini-news-crawler'
export GIT_STATE="$(git rev-list -1 HEAD --abbrev-commit)"
export GIT_COMMIT_SHA="$(git rev-parse HEAD)" # big commit
export GIT_SHORT_SHA="${GIT_COMMIT_SHA:0:7}" # first 7 chars: Riccardo reproducing what CB does for me.
export APP_VERSION="$(cat VERSION)"
#export APP_VERSION_LATEST="latest"
export MESSAGGIO_OCCASIONALE="${MESSAGGIO_OCCASIONALE:-MsgOcc Non datur}"
export RAILS_MASTER_KEY="${RAILS_MASTER_KEY:-foobarbaz}"
export BUCKET="${BUCKET:-bucket-non-datur}"
#- "${_REGION}-docker.pkg.dev/${PROJECT_ID}/${APP_NAME}/${APP_NAME}:sha-$SHORT_SHA"

# get from secret manager
#SECRET_REGION=$(gcloud secrets versions access latest --secret=gemini-news-crawler_REGION)

# Derived info
CLOUDRUN_PROJECT_ID="$PROJECT_ID"
# VER non lo posso calcolare da CB vanilla, serve un shell script :/
UPLOADED_IMAGE_WITH_VER="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${APP_NAME}/${APP_NAME}:v$APP_VERSION"
UPLOADED_IMAGE_WITH_LATEST_VERSION="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${APP_NAME}/${APP_NAME}:latest"
UPLOADED_IMAGE_WITH_SHA="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${APP_NAME}/${APP_NAME}:sha-$GIT_SHORT_SHA"

# $1 can be unbound
if [ latest = "${1:-sthElse}" ]; then
  echo '🗞️ Overriding both SHA/VER to LATEST (or whatever DOLL1 says) since you gave me DOLL1:'
  export UPLOADED_IMAGE_WITH_SHA="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${APP_NAME}/${APP_NAME}:latest"
  export UPLOADED_IMAGE_WITH_VER="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${APP_NAME}/${APP_NAME}:latest"
else
  echo You didnt give me any DOLL_1.. continuing
fi

echo "---- DEBUG  ----"
echo "PROJECT_ID: $PROJECT_ID"
echo "DEPLOY_VERSION: $DEPLOY_VERSION"
echo "APP_VERSION:    $APP_VERSION"
echo "GIT_SHORT_SHA:  $GIT_SHORT_SHA"
echo "UPL_IMG_W/_SHA: $UPLOADED_IMAGE_WITH_SHA"
echo "UPLOADED_IMAGE_WITH_VER: $UPLOADED_IMAGE_WITH_VER"
# echo "DATABASE_HOST:  $DATABASE_HOST"
# echo "DATABASE_HOST:  $DATABASE_HOST"
# echo "DATABASE_NAME:  $DATABASE_NAME"
echo "DATABASE_URL_DEV: $DATABASE_URL_DEV"
echo "DATABASE_URL_PROD: $DATABASE_URL_PROD"
echo "---- /DEBUG ----"

set -x


# Change AppName if deployed from Carlessian computer
if hostname | egrep 'ricc-macbookpro|derek' ; then
  #echo 'I believe this code wont work given how BASH vars suck '
  export APP_NAME='gemini-news-crawler-manhouse'
fi

echo 'WARNING: For this to work you need to 1. upload your ENVRC to Secret MAnager 2. make the SA able to access SM and 3. call it properly.'

#########
# PROD
# che non puo andare perche le var sono di dev
#  url: <%= ENV['DATABASE_URL_PROD'] %>
##########

gcloud --project "$CLOUDRUN_PROJECT_ID" \
    beta run deploy "${APP_NAME}-prodold" \
      --image  "$UPLOADED_IMAGE_WITH_VER" \
      --platform managed \
      --memory "2048Mi" \
      --region "$GCLOUD_REGION" \
      --set-env-vars='description=created-from-bin-slash-cb-push-to-cloudrun-sh OBSOLETE use cbp2cr-magic instead' \
      --set-env-vars='fav_color=purple' \
      --set-env-vars="GIT_STATE=$GIT_STATE" \
      --set-env-vars="APP_VERSION=$APP_VERSION" \
      --set-env-vars="SECRET_KEY_BASE=TODO" \
      --set-env-vars="RAILS_MASTER_KEY=$RAILS_MASTER_KEY" \
      --set-env-vars="RAILS_ENV=production" \
      --set-env-vars="RAILS_SERVE_STATIC_FILES=true" \
      --set-env-vars="MESSAGGIO_OCCASIONALE=$MESSAGGIO_OCCASIONALE" \
      --set-env-vars="RAILS_LOG_TO_STDOUT=yesplease" \
      --set-env-vars="DATABASE_URL_PROD=$DATABASE_URL_PROD" \
      --set-env-vars="BUCKET=$BUCKET" \
      --set-env-vars=APP_NAME='GemiNews CB-PROD OBSOLETE' \
      --set-secrets="/secretenvrc/gemini-news-crawler-envrc=gemini-news-crawler-envrc:latest" \
      --allow-unauthenticated

# illegal --set-env-vars="PORT=8080" \

# make sure we exit 0 with a string (set -e guarantees this)
echo All is Done.
