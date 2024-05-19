

auth:
	gcloud auth application-default login
	gcloud auth login
	gcloud config set project palladius-genai

# Error: ERROR: (gcloud.auth.application-default.login) Invalid file format. See https://developers.google.com/api-client-library/python/guide/aaa_client_secrets
#        Expected a JSON object with a single property for a "web" or "installed" application
# auth4gemini:
# 	echo 'Read this: https://ai.google.dev/gemini-api/docs/oauth'
# 	gcloud auth application-default login --no-browser \
# 	    --client-id-file=private/geminews-gcs-readwriter-key.json \
# 	    --scopes='https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/generative-language.retriever'

auth-as-sa:
	gcloud auth activate-service-account --key-file=private/geminews-gcs-readwriter-key.json
# echo "GOOGLE_APPLICATION_CREDENTIALS=$$GOOGLE_APPLICATION_CREDENTIALS"


demo01:
	cd webapp && cat docs/demo/demo01-rails-console.rb | rails console
demo02:
	cd webapp && cat docs/demo/demo02-rails-console.rb | rails console
demo03:
	cd webapp && cat docs/demo/demo03-rails-console.rb | rails console
demo04:
	cd webapp && cat docs/demo/demo04-rails-console.rb | rails console
