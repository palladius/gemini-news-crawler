#!/bin/bash

#####################################################################################################
# Runs both DEV and PROD
# Usage: $0 <dev|prod>
#
#Wrong:
# expected: Image 'europe-west1-docker.pkg.dev/palladius-genai/gemini-news-crawler-manhouse/gemini-news-crawler-manhouse:latest' not found.
#  reality:        europe-west1-docker.pkg.dev/palladius-genai/gemini-news-crawler/gemini-news-crawler
#####################################################################################################

export DEPLOY_VERSION='2.0.1'

if [ -f .envrc ] ; then
  echo Looks like youre local since I see your envrc.
  . .envrc
else
  echo 'Riccardo NOT LOCAL probably in the Cloud'
fi

# if [ -f /secretenvrc/gemini-news-crawler-envrc ] ; then
#   echo Looks like youre on Cloud Run mounting an envrc directly form SM. You could be protecteder. # :)
#   . /secretenvrc/gemini-news-crawler-envrc
# else
#   echo 'Riccardo NOT Secret or it doesnt work with this weird path. to be sure, lets check. Lets see the mounts:'
#   #ls -al /
#   #ls -al /secretenvrc
#   mount
# fi

if which gcloud ; then
  echo "👒 [GCLOUD AVAILABLE!] Parsing secret wich gcloud - wOOOt 2024 news"
  gcloud secrets versions access latest --secret=gemini-news-crawler-envrc > .tmp.gcloud-envrc ||
    rm .tmp.gcloud-envrc  # remove if failed
  ls -al .tmp.gcloud-envrc
  grep DESCRIPTION .tmp.gcloud-envrc
  source .tmp.gcloud-envrc
fi

function _usage() {
  echo "Usage: $0 [dev|prod] [latest]"
  exit 142
}

# These variables I need to know BEFORE the dev vs PROD part. Or maybe I can skip to aftr them
################################################
# ENV set
################################################
export APP_NAME='gemini-news-crawler'
export AR_NAME='gemini-news-crawler'
export APP_NAME_TO_DEPLOY='gemini-news-crawler'
export GCLOUD_REGION="${GCLOUD_REGION:-europe-west1}"
export GIT_STATE="$(git rev-list -1 HEAD --abbrev-commit)"
export GIT_COMMIT_SHA="$(git rev-parse HEAD)" # big commit
export GIT_SHORT_SHA="${GIT_COMMIT_SHA:0:7}" # first 7 chars: Riccardo reproducing what CB does for me.
export APP_VERSION="$(cat VERSION)"
#export APP_VERSION_LATEST="latest"
#export MESSAGGIO_OCCASIONALE="${MESSAGGIO_OCCASIONALE:-MsgOcc Non datur in MAGIC}"
export MESSAGGIO_OCCASIONALE="MsgOcc Non datur in MAGIC"
export RAILS_MASTER_KEY="${RAILS_MASTER_KEY:-foobarbaz}"
export BUCKET="${BUCKET:-bucket-non-datur}"
# Change AppName if deployed from Carlessian computer
if hostname | egrep 'ricc-macbookpro|derek|penguin' ; then
  #echo 'I believe this code wont work given how BASH vars suck '
  export APP_NAME_TO_DEPLOY='gemini-news-crawler-manhouse'
fi

# Check dev or prod
case "$1" in
   dev | development )
    export APP_TO_DEPLOY="${APP_NAME_TO_DEPLOY}-dev"
    export RAILS_ENV=development
    ;;

  prod | production )
    export APP_TO_DEPLOY="${APP_NAME_TO_DEPLOY}-prod"
    export RAILS_ENV=production
    ;;

  *) # else
    _usage
    ;;
esac


set -euo pipefail


# get from secret manager
#SECRET_REGION=$(gcloud secrets versions access latest --secret=gemini-news-crawler_REGION)

# Derived info
CLOUDRUN_PROJECT_ID="$PROJECT_ID"
# VER non lo posso calcolare da CB vanilla, serve un shell script :/
           UPLOADED_IMAGE_WITH_VER="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_NAME}/${AR_NAME}:v$APP_VERSION"
UPLOADED_IMAGE_WITH_LATEST_VERSION="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_NAME}/${AR_NAME}:latest"
           UPLOADED_IMAGE_WITH_SHA="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_NAME}/${AR_NAME}:sha-$GIT_SHORT_SHA"

# $1 can be unbound
if [ latest = "${2:-sthElse}" ]; then
  echo '🗞️ Overriding both SHA/VER to LATEST (or whatever DOLL1 says) since you gave me DOLL1:'
  export UPLOADED_IMAGE_WITH_SHA="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_NAME}/${AR_NAME}:latest"
  export UPLOADED_IMAGE_WITH_VER="${GCLOUD_REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_NAME}/${AR_NAME}:latest"
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
echo "APP_TO_DEPLOY: $APP_TO_DEPLOY"

# echo "DATABASE_HOST:  $DATABASE_HOST"
# echo "DATABASE_HOST:  $DATABASE_HOST"
# echo "DATABASE_NAME:  $DATABASE_NAME"
echo "---- /DEBUG ----"

set -x




echo 'WARNING: For this to work you need to 1. upload your ENVRC to Secret MAnager 2. make the SA able to access SM and 3. call it properly.'

#########
# DEV
# Uses: DATABASE_URL_DEV
# TODO when it works delete DATABASE_blah
#########

gcloud --project "$CLOUDRUN_PROJECT_ID" \
    beta run deploy "$APP_TO_DEPLOY" \
      --image  "$UPLOADED_IMAGE_WITH_VER" \
      --platform managed \
      --memory "2048Mi" \
      --region "$GCLOUD_REGION" \
      --set-env-vars='description=created-from-bin-slash-cb-push-to-cloudrun-sh' \
      --set-env-vars="GIT_STATE=$GIT_STATE" \
      --set-env-vars="APP_VERSION=$APP_VERSION" \
      --set-env-vars="RAILS_MASTER_KEY=$RAILS_MASTER_KEY" \
      --set-env-vars="RAILS_ENV=$RAILS_ENV" \
      --set-env-vars="RAILS_SERVE_STATIC_FILES=true" \
      --set-env-vars="MESSAGGIO_OCCASIONALE=$MESSAGGIO_OCCASIONALE" \
      --set-env-vars="RAILS_LOG_TO_STDOUT=yesplease" \
      --set-env-vars="DATABASE_URL_DEV=$DATABASE_URL_DEV" \
      --set-env-vars="DATABASE_URL_PROD=$DATABASE_URL_PROD" \
      --set-secrets="/secretenvrc/gemini-news-crawler-envrc=gemini-news-crawler-envrc:latest" \
      --allow-unauthenticated


# Dubito serva:       --set-env-vars="SECRET_KEY_BASE=TODO" \

# ILLEGAL       --set-env-vars="PORT=8080" \
#      --update-secrets=gemini-news-crawler_SECRET_KEY=gemini-news-crawler_SECRET_KEY:latest \
#      --service-account="gemini-news-crawler-docker-runner@$PROJECT_ID.iam.gserviceaccount.com" \
# Useless:
# --set-env-vars="BUCKET=$BUCKET" \
# --set-env-vars="DATABASE_HOST=$DATABASE_HOST" \
# --set-env-vars="DATABASE_NAME=$DATABASE_NAME" \
# --set-env-vars="DATABASE_USER=$DATABASE_USER" \
# --set-env-vars="DATABASE_PASS=$DATABASE_PASS" \


# make sure we exit 0 with a string (set -e guarantees this)
echo All is Done.
