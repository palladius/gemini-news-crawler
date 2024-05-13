
crawl:
	ruby crawl.rb | tee sample-crawl-output.txt

crawl-a-lot:
	echo Crawling a VERY high amaount
	MAX_ARTICLE_SIZE=10 MAX_WEBSITES=50 ./crawl.rb
crawl-a-REAL-lot:
	echo Crawling as much as I have basically
	MAX_ARTICLE_SIZE=1000 MAX_WEBSITES=5000 ./crawl.rb
crawl-a-few:
	echo Crawling just a few when testing new functionalities
	MAX_ARTICLE_SIZE=2 MAX_WEBSITES=5 ./crawl.rb

crawl-continuously:
	MAX_ARTICLE_SIZE=12345 MAX_WEBSITES=5000 SLEEP_FOR_SECONDS=600 bin/crawl-continuously
crawl-continuously-minitest:
	MAX_ARTICLE_SIZE=2 MAX_WEBSITES=3 SLEEP_FOR_SECONDS=10 bin/crawl-continuously

# MaxArticleSize = ENV.fetch('MAX_ARTICLE_SIZE', '2').to_i  # 10 # todo 100
# MaxNewsWebsites = ENV.fetch('MAX_WEBSITES', '3').to_i  # 50 # todo 100
# RssCacheInvalidationMinutes = = ENV.fetch('RSS_CACHE_INVALIDATION_MINUTES', '15').to_i  # 15 # 15 minutes


feedbag-test:
	ruby feedbag-test.rb

newsapi-test:
	./news-api-test.sh 'Trump%20vs%20Biden'
# empty ./news-api-test.sh 'Riccardo%20Carlesso'

clean-articles:
	rm -rf out/* out/*/* out/feedjira/

test-gcp-comntinuously:
	watch SKIP_CRAWLING=true ./crawl.rb
