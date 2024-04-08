# #!/bin/bash

# # Welcome to `00-init.sh`, created by `codelabba.rb`

# source .envrc

# # Ensures the GCLOUD_CONFIG and friends are parsed correctly, or it will nicely fail at first unknown missing VAR
# set -u
# # Im not 100% sure set -e will always work.. but you can uncomment at your own risk ;)
# #set -e

# gcloud config configurations create $GCLOUD_CONFIG |
# gcloud config configurations activate $GCLOUD_CONFIG ||
#     gcloud config configurations create $GCLOUD_CONFIG
# gcloud config set account $ACCOUNT
# gcloud config set project $PROJECT_ID
# PROJECT_ID=$(gcloud config get-value project)

#     # Enable APIs...
# gcloud services enable \
#     artifactregistry.googleapis.com \
#     cloudbuild.googleapis.com \
#     clouddeploy.googleapis.com \
#     compute.googleapis.com \
#     container.googleapis.com \
#     logging.googleapis.com \
#     run.googleapis.com

# #gcloud services enable eventarc.googleapis.com
# # gcloud services enable \
# # container.googleapis.com \
# # gkehub.googleapis.com \
# # multiclusterservicediscovery.googleapis.com \
# # multiclusteringress.googleapis.com \
# # trafficdirector.googleapis.com \

# # Set defaults..
# #gcloud config set run/region $REGION
# #gcloud config set run/platform managed
# #gcloud config set eventarc/location $REGION
# # # never tried but copied from here: https://cloud.google.com/compute/docs/regions-zones/changing-default-zone-region#gcloud
# #gcloud compute project-info add-metadata --metadata google-compute-default-region=europe-west1,google-compute-default-zone=europe-west1-b

# # Get info re current project
# gcloud compute project-info describe

# gcloud config list | lolcat

#     # If you need to aunthenticate your app
# #This is needed when you want to use Python, Node, .. APIs and you cant / dont
# #want to use a service account.
# #
# # gcloud auth application-default login
# #
# #Once I got a mysterious error which asked me to RE-authorize:
# #
# # gcloud auth login --update-adc
# #

# touch ".$APPNAME.appname"
