#!/bin/bash

set -euo pipefail

source '../_env_gaic.sh'

# Example for spaces:
# 'Trump%20vs%20Biden'
SEARCH_QUERY="${1:-bitcoin}"

echo "CAling with this API KEY: $NEWSAPI_COM_KEY"
FINAL_FILE="cache/newsapi_org.search4.$SEARCH_QUERY.json"

if [ -f "$FINAL_FILE" ]; then
    echo File already exists. Im gonna save some QPS for limited license.
else
    curl "https://newsapi.org/v2/everything?q=$SEARCH_QUERY&apiKey=${NEWSAPI_COM_KEY}" | tee \
        "$FINAL_FILE"
fi

cat     "$FINAL_FILE" | jq # .status
