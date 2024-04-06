#!/bin/bash

function _fatal() {
    echo "[FATAL] $*" >&1
    exit 42
}
function _after_allgood_post_script() {
    echo "[$0] All good on $(date)"
    CLEANED_UP_DOLL0="$(basename $0)"
    touch .executed_ok."$CLEANED_UP_DOLL0".touch
}

# Created with codelabba.rb v.2.3
# You can use `direnv allow` to make this work automagically.
source .envrc || _fatal 'Couldnt source this'
set -x
set -e # exists at first error
set -u # fails at first undefined VAR (!!)

########################
# Add your code here
########################


# GCS bucket key
SA_NAME="geminews-gcs-readwriter"
# its importahnt this key is shared across the project - in a private, .gitignored fashion!
KEY_DIR="../private/"

gcloud iam service-accounts create ${SA_NAME} \
  --display-name "[GemiNews] GCS Bucket Access Account" ||
        echo Already exists

mkdir -p $KEY_DIR/

if [ ! -f $KEY_DIR/${SA_NAME}-key.json ] ; then
    echo "Creating key once:"
    gcloud iam service-accounts keys create $KEY_DIR/${SA_NAME}-key.json  \
        --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
fi

# gsutil iam ch \
#     serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
#         roles/storage.objectAdmin \
#             "gs://${BUCKET_NAME}"
gsutil iam ch serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com:objectAdmin gs://$BUCKET_NAME

#gsutil iam ch serviceAccount:my-service-account@project.iam.gserviceaccount.com:objectAdmin gs://my-project/my-bucket





########################
# /End of your code here
########################
_after_allgood_post_script
echo '👍 Everything is ok. But Riccardo you should think about 🌍rewriting it in Terraform🌍'
