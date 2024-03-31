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

if [ -f /secretenvrc/puffintours-envrc ] ; then
  echo Looks like youre on Cloud Run mounting an envrc directly form SM. You could be protecteder. # :)
  . /secretenvrc/puffintours-envrc
else
  echo Riccardo NOT Secret
fi

set -euo pipefail

################################################
# ENV set
################################################
export GCLOUD_REGION="${GCLOUD_REGION:-europe-west1}"
export APP_NAME='puffintours'
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
#SECRET_REGION=$(gcloud secrets versions access latest --secret=PUFFINTOURS_REGION)

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
echo "DEPLOY_VERSION:   $DEPLOY_VERSION"
echo "APP_VERSION:   $APP_VERSION"
echo "GIT_SHORT_SHA: $GIT_SHORT_SHA"
echo "UPLOADED_IMAGE_WITH_SHA: $UPLOADED_IMAGE_WITH_SHA"
echo "DATABASE_HOST: $DATABASE_HOST"
echo "DATABASE_NAME: $DATABASE_NAME"
echo "---- /DEBUG ----"

# TODO(ricc): As a future iteration, tag and push the v0.1.2 too and use that for CRun
#docker tag "$TAGGED_IMAGE" "$TAGGED_IMAGE:v`./version.sh`"

# copy locally. Changing name for localhost testing :)
#gsutil cp "gs://${PROJECT_ID}-state/.env.gcs" .envrc.from-gcs

# source = now I have all info here even without direnv :)
# This exposes REGION, APP_ENV, APP_VERSION, REGION, GIT_STATE
#source .envrc.from-gcs

set -x

#################################################################
# TODO(ricc): remove the clutter when this is proven to work.
#################################################################
# Note from Marc: this is not needed since its baked into CB
# --set-env-vars="APP_VERSION=$APP_VERSION" \
# Not used anymore
#--set-env-vars="APPLICATION_DEFAULT_CREDENTIALS=/sa.json" \
#  --update-secrets=PUFFINTOURS_OAUTH_CLIENT_SECRET_JSON_FILE_CONTENT=PUFFINTOURS_OAUTH_CLIENT_SECRET_JSON_FILE_CONTENT:latest \
#################################################################

# Ho creato questo: (vedi https://console.cloud.google.com/run/detail/europe-west6/${APP_NAME}-poor-cb/yaml/view?hl=IT&project=ror-goldie )
# limits:
#             cpu: 2000m
#             memory: 2Gi

# Change AppName if deployed from Carlessian computer
if hostname | egrep 'ricc-macbookpro|derek' ; then
  #echo 'I believe this code wont work given how BASH vars suck '
  export APP_NAME='puffintours-manhouse'
fi

gcloud --project "$CLOUDRUN_PROJECT_ID" \
    beta run deploy "${APP_NAME}-prod" \
      --image    "$UPLOADED_IMAGE_WITH_VER" \
      --platform managed \
      --memory "2048Mi" \
      --region   "$GCLOUD_REGION" \
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
      --set-secrets="/secretenvrc/puffintours-envrc=puffintours-envrc:latest" \
      --allow-unauthenticated


#      --update-secrets=PUFFINTOURS_SECRET_KEY=PUFFINTOURS_SECRET_KEY:latest \
#      --service-account="puffintours-docker-runner@$PROJECT_ID.iam.gserviceaccount.com" \


# make sure we exit 0 with a string (set -e guarantees this)
echo All is Done.
