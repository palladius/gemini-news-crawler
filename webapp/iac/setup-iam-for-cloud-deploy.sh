#!/bin/bash

set -euo pipefail

echo "PROJECT_ID: $PROJECT_ID"
echo "PROJECT_NUMBER: $PROJECT_NUMBER"

# https://cloud.google.com/deploy/docs/deploy-app-run

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role="roles/clouddeploy.jobRunner"

gcloud iam service-accounts add-iam-policy-binding $PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role="roles/iam.serviceAccountUser" \
    --project=$PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role="roles/run.developer"

echo All good.
