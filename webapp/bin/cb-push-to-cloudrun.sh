#!/bin/bash

#####################################################################################################
# Since CB doesnt have access to a number of vars, I'm trying to add them as secret
# AND THEN retrieve them from CB. If it works locally, it should hopefully also work remotely
# As long as CB has access to those secrets (CB SA was enabled to read secrets).
#####################################################################################################

export DEPLOY_VERSION='1.0.2b'
#direnv allow "$(git rev-parse --show-toplevel)"
# if it fails no probs... yet

if [ -f .env.sh ] ; then
  echo Looks like youre local
  . .env.sh
else
  echo Riccardo NOT LOCAL
fi

if [ -f /secretenvrc/gemini-news-crawler-envrc ] ; then
  echo Looks like youre on Cloud Run mounting an envrc directly form SM. You could be protecteder. # :)
  . /secretenvrc/gemini-news-crawler-envrc
else
  echo Riccardo NOT Secret
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
  echo Overriding the version to LATEST:
  export UPLOADED_IMAGE_WITH_SHA="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${APP_NAME}/${APP_NAME}:latest"
fi

echo "---- DEBUG  ----"
echo "DEPLOY_VERSION: $DEPLOY_VERSION"
echo "APP_VERSION:    $APP_VERSION"
echo "GIT_SHORT_SHA:  $GIT_SHORT_SHA"
echo "UPL_IMG_W/_SHA: $UPLOADED_IMAGE_WITH_SHA"
# echo "DATABASE_HOST:  $DATABASE_HOST"
# echo "DATABASE_HOST:  $DATABASE_HOST"
# echo "DATABASE_NAME:  $DATABASE_NAME"
echo "---- /DEBUG ----"

set -x


# Change AppName if deployed from Carlessian computer
if hostname | egrep 'ricc-macbookpro|derek' ; then
  #echo 'I believe this code wont work given how BASH vars suck '
  export APP_NAME='gemini-news-crawler-manhouse'
fi

echo 'WARNING: For this to work you need to 1. upload your ENVRC to Secret MAnager 2. make the SA able to access SM and 3. call it properly.'

gcloud --project "$CLOUDRUN_PROJECT_ID" \
    beta run deploy "${APP_NAME}-prod" \
      --image  "$UPLOADED_IMAGE_WITH_VER" \
      --platform managed \
      --memory "2048Mi" \
      --region "$GCLOUD_REGION" \
      --set-env-vars='description=created-from-bin-slash-cb-push-to-cloudrun-sh' \
      --set-env-vars='fav_color=purple' \
      --set-env-vars="GIT_STATE=$GIT_STATE" \
      --set-env-vars="APP_VERSION=$APP_VERSION" \
      --set-env-vars="SECRET_KEY_BASE=TODO" \
      --set-env-vars="RAILS_MASTER_KEY=$RAILS_MASTER_KEY" \
      --set-env-vars="RAILS_ENV=production" \
      --set-env-vars="RAILS_SERVE_STATIC_FILES=true" \
      --set-env-vars="MESSAGGIO_OCCASIONALE=$MESSAGGIO_OCCASIONALE" \
      --set-env-vars="RAILS_LOG_TO_STDOUT=yesplease" \
      --set-env-vars="DATABASE_HOST=$DATABASE_HOST" \
      --set-env-vars="DATABASE_NAME=$DATABASE_NAME" \
      --set-env-vars="DATABASE_USER=$DATABASE_USER" \
      --set-env-vars="DATABASE_PASS=$DATABASE_PASS" \
      --set-env-vars="BUCKET=$BUCKET" \
      --set-secrets="/secretenvrc/gemini-news-crawler-envrc=gemini-news-crawler-envrc:latest" \
      --allow-unauthenticated


#      --update-secrets=gemini-news-crawler_SECRET_KEY=gemini-news-crawler_SECRET_KEY:latest \
#      --service-account="gemini-news-crawler-docker-runner@$PROJECT_ID.iam.gserviceaccount.com" \


# make sure we exit 0 with a string (set -e guarantees this)
echo All is Done.
