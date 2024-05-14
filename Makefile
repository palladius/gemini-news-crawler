

auth:
	gcloud auth application-default login
	gcloud auth login

auth-as-sa:
	gcloud auth activate-service-account --key-file=private/geminews-gcs-readwriter-key.json
	echo "GOOGLE_APPLICATION_CREDENTIALS=$$GOOGLE_APPLICATION_CREDENTIALS"
