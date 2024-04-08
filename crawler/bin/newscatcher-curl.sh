#!/bin/bash

set -euo pipefail

if [ -f ../_env_gaic.sh ] ; then
    echo File found.
    source ../_env_gaic.sh
fi

API_KEY="$NEWSCATCHER_API"

echo "Querying newscatcherapi via API key: '$API_KEY'"
# My key is v3..
curl -XGET 'https://v3-api.newscatcherapi.com/api/search?q=Tesla' -H "x-api-token: $API_KEY"
