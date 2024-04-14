
DOCKER_VERSION = $(shell cat VERSION)

# i cant believe it that a new rails install doesnt work but hey here it is
# https://stackoverflow.com/questions/74904688/esbuild-throwing-error-could-not-resolve-import-statement-while-setting-up
install:
	rbenv install 3.2.2
	npm i @hotwired/turbo-rails
	npm i "@hotwired/stimulus"
	rails stimulus:install
#	yarn upgrade

# To fix dev for derek, I had to remove application.CSS and application.js from app/builds. Weird
fix-derek:
	rm app/builds/application.js app/builds/application.css

dev: run

# ricc@derek:🏡~/git/gemini-news-crawler/webapp$ rails assets:clean
run:
	rails assets:precompile
	rails s

run-prod:
	RAILS_ENV=production rake assets:precompile
	RAILS_ENV=production rails s -p 3001 -b 0.0.0.0


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
	bin/seed-forever

test-cat-article-association:
	echo  ArticleTag.count | rails c
	echo  Category.first.articles | rails c


cloud-deploy-setup:
	gcloud deploy apply --file=clouddeploy.yaml --region=europe-west1 --project=palladius-genai

# https://discuss.rubyonrails.org/t/rails-master-key-and-per-environment-init/82615
# My MASTER)_KEY is in ENV now.
credentials-edit:
	bin/rails credentials:edit -e production
credentials-edit-dev:
	bin/rails credentials:edit -e development


build: docker-build
docker-build:
	sudo docker build -t geminews:v$(DOCKER_VERSION) .
docker-run:
	./entrypoint-8080.sh
#	docker run -it -p 8080:8080 geminews:v$(DOCKER_VERSION)

# Latyest Magic script
push-latest-to-dev-manhouse:
	bin/cb-push-to-cloudrun-magic.sh dev latest

postgres-start-locally-mac:
	brew services start postgresql
