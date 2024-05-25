
DOCKER_VERSION = $(shell cat VERSION)

# i cant believe it that a new rails install doesnt work but hey here it is
# https://stackoverflow.com/questions/74904688/esbuild-throwing-error-could-not-resolve-import-statement-while-setting-up
install:
	rbenv install 3.2.2
	npm i @hotwired/turbo-rails
	npm i "@hotwired/stimulus"
	rails stimulus:install
	if_mac bundle config build.unicode --with-cflags=\"-Wno-incompatible-function-pointer-types\"
	bundle install
#	yarn upgrade

# To fix dev for derek, I had to remove application.CSS and application.js from app/builds. Weird
fix-derek:
	rm app/builds/application.js app/builds/application.css

dev:
	echo 'OBSOLETE. Instead use:     make run-dev'

# ricc@derek:🏡~/git/gemini-news-crawler/webapp$ rails assets:clean
run-dev:
	bundle exec rails assets:precompile
	bundle exec rails s
run-dev-insecure:
	bundle exec rails assets:precompile
	bundle exec rails s -b 0.0.0.0

run-prod:
# fioxes this: objc[92630]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES RAILS_ENV=production rails assets:precompile
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES RAILS_ENV=production rails db:migrate
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES RAILS_ENV=production rails s -p 3001 -b 0.0.0.0


regenerate-DANGEROUS-DO-NOT-DO-IT:
# summary = description
	echo TODO ricc make it recreate it if you forget something..
	echo Article has now a 4th migration so i wouldnt suggest to redo it.

	rails g controller pages stats about search

	# rails generate scaffold Article \
	# 	title:string summary:text content:text \
	# 	author:string \
	# 	link:string published_date:datetime \
	# 	image_url:string feed_url:string guid:string \
	# 	hidden_blurb:text \
	# 	language:string \
	# 	active:boolean \
	# 	ricc_internal_notes:text ricc_source:string \
	# 	 --force

	rails generate scaffold category name:string ricc_internal_notes:text --force

# https://stackoverflow.com/questions/51509361/i-have-a-rails-blog-where-articles-can-have-multiple-categories-how-do-i-struc
	rails generate model article_tag article:references category:references ricc_internal_notes:text  --force


drop-and-recreate-db-dev:
	DESTROY_ALL_BEFORE=YES_WHY_NOT rake db:seed
#	RAILS_ENV=development rake db:drop db:migrate db:seed

seed-forever:
	bundle exec bin/seed-forever
seed-forever-prod:
	RAILS_ENV=production bundle exec bin/seed-forever

test-cat-article-association:
	echo  ArticleTag.count | rails c
	echo  Category.first.articles | rails c


cloud-deploy-setup:
	gcloud deploy apply --file=clouddeploy.yaml --region=europe-west1 --project=palladius-genai

# https://discuss.rubyonrails.org/t/rails-master-key-and-per-environment-init/82615
# My MASTER)_KEY is in ENV now.

# Esempio di come fare la get:
# - Rails.application.credentials.env (tutto il mio oro)
# - Rails.application.credentials.env.NEWSAPI_COM_KEY


credentials-edit-prod:
#	bin/rails credentials:edit -e production
	RAILS_ENV=production EDITOR="code --wait" rails credentials:edit

credentials-edit-dev:
#bin/rails credentials:edit -e development
	RAILS_ENV=development EDITOR="code --wait" rails credentials:edit


build: docker-build
docker-build:
	sudo docker build -t geminews:v$(DOCKER_VERSION) .
docker-run:
#	./entrypoint-8080.sh
	docker run -it -p 8080:8080 geminews:v$(DOCKER_VERSION)
docker-run-bash:
#	./entrypoint-8080.sh
	sudo docker run -it -p 8080:8080 geminews:v$(DOCKER_VERSION) bash

# Latyest Magic script
push-latest-to-dev-manhouse:
	bin/cb-push-to-cloudrun-magic.sh dev latest

postgres-start-locally-mac:
	brew services start postgresql

postgres-schema:
	echo "SELECT * FROM information_schema.columns WHERE table_name = 'articles'; " | rails dbconsole | tee articles.schema

sample-gcp-article-neighbours:
	echo 'Article.find(10170).closest_articles(size: 5, similarity_field: :title_embedding).map{|x| x.title}'| rails c

# Derek (works):
# gemini-news-crawler True palladiusbonton@gmail.com palladius-genai us-central1-b us-central1
# from gcloud-auth-debug: ..

# model = gemini-1.0-pro-002
auth:
	gcloud auth application-default login
	gcloud auth login
	gcloud config  set project  palladius-genai
	gcloud config  set compute/region us-central1
	gcloud config  set compute/zone us-central1-b

# Thisd wotks on my LInux machine but not on my Mac :/
test-llm-gemini:
	echo "GeminiLLM.complete prompt: 'Hi my name is Riccar'" | rails c
test-llm-vertex:
	echo "VertexLLM.complete prompt: 'Hi my name is Riccar'" | rails c

compute_embeddings_for_all:
	echo Article.compute_embeddings_for_all | rails c
