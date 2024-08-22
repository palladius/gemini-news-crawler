
DOCKER_VERSION=$(cat VERSION)

#cat  .envrc | egrep -v '^$|layout' > .envrc4dockerrun
#cat ../_env_gaic.sh | sed -e 's/export //g' > .envrc4dockerrun

# -e "RAILS_MASTER_KEY=$RAILS_MASTER_KEY"
echodo docker run -it -p 8080:8080 --env-file .envrc4dockerrun "geminews:v$DOCKER_VERSION"
#echodo docker run -it -p 8080:8080 --env-file ../_env_gaic.sh "geminews:v$DOCKER_VERSION"
