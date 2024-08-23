## Open bugs

* b/101 NewsRetriever doesnt work on CloudRun. Cant seemt o find ENV. I'm considering using the builtin cryptic config instead.
* b/102 Doesnt work on GCE - yet. getting there thanks to Neha
* b/103 bad encoding http://localhost:3000/articles/10346. note \342\200\231 is a '!
* b/104 PalmLLM gecko-01 only supports English -> do not try italian stuff.
* b/105 in CB step 1 (docker build) RAC is nil. I get this error:
```
/rails/config/initializers/riccardo99.rb:60:in `<main>'
                                                ^^^^^^
ShowDemoz = Rails.application.credentials['env'].fetch(:SHOW_DEMOZ, false).to_bool

NoMethodError: undefined method `fetch' for nil:NilClass (NoMethodError)
bin/rails aborted!
```
## Features
* b/106 added quota for new models on Friday May 27.

* gemini-1.5-pro-preview-0514 -> gemini-1.5-pro-001
* gemini-1.5-flash-preview-0514 -> gemini-1.5-flash-001


## Changelog

2024-08-22 v0.3.69 [dev] fixing https://github.com/palladius/gemini-news-crawler/issues/2
2024-08-22 v0.3.68 [dev] Small bug in embedding exception handling
2024-08-22 v0.3.67 [dev] Audio seems broken still :/ but good progress here
2024-08-22 v0.3.66 [dev] Demo03 is now a bijou thanks to toggling with JS! Thanks Gemini!
2024-08-22 v0.3.65 [dev] Updated rails to 7.2.0 (was 7.1.3.4) and a minute ago it was 7.1.3.2. Also added some default
                         values to Article to fix the Demo2 UI page (failed for missing article fields - which I
                         defaulted to null)
2024-08-20 v0.3.64 [dev] Removed  `CarlessianChat` from ChatController. broke PPROD in rails c. PS Chromebook is HARD!
2024-08-20 v0.3.63 [dev] fixed `@articleregions`.
2024-06-10 v0.3.62 [dev] `rubocop -a` earthquake. Just because I met the creator of it I think I owe him.
2024-06-01 v0.3.61 [dev] adding `sorbet` and a chat page with Gemini guidance. Then removed sorbet :)
2024-05-31 v0.3.60 [dev] small changes during the day
2024-05-30 v0.3.59 [dev] [Penguin] added `aiuto` for demo
2024-05-?? v0.3.58 ???
2024-05-25 v0.3.57 [dev/ops] [Mac] Ops: cleaned up useless scripts/ Dev: Enriched the demo3 with more keywords.
2024-05-25 v0.3.57 [dev] [Mac] Prod was broken given some article has NIL published_date. `rescue` to the rescue.
2024-05-25 v0.3.56 [dev] [Mac] (again working on a weekend) fixed articles#show: now super fancy.
2024-05-24 v0.3.55 [dev] [derek] Demo3: fix horrible UI
2024-05-24 v0.3.54 [dev] [derek] Demo4: fixed delete() function
2024-05-24 v0.3.53 [dev] [derek] BREAKING CHANGE - CSS `flex` removed from main. Seems to have fixed EVERYTHING
2024-05-24 v0.3.52 [dev] [derek] 4 googley button helpers
2024-05-24 v0.3.51 [dev] [derek] demo3 beautification
2024-05-24 v0.3.50 [dev] [derek] minor migliorie
2024-05-23 v0.3.49 [dev] [derek] Added Carlessian URL to UI Assistant demo two.
2024-05-23 v0.3.48 [dev] [mac] Added Carlessian URL to toolchain. It works fabulously.
2024-05-23 v0.3.47 [dev] small nits for awesomization of #demo4
2024-05-22 v0.3.46 [dev] better country management in tool for #demo4
2024-05-21 v0.3.45 [dev] tool is more verbose in crestaing an article #demo4
2024-05-21 v0.3.44 [dev] One of those useless refactorings which breaks everything
2024-05-21 v0.3.43 [dev] Tool bugfix
2024-05-21 v0.3.42 [OPS] Full fledged debugging for `RAILS_MASTER_KEY`: both in `/pages/gcp` and in Logging. Seatch for `RailsCredEnvObj`
2024-05-21 v0.3.41 [OPS] Adding `RAILS_MASTER_KEY` to basically all CB steps to fix the Rails.cred.ENV error part. b.105
2024-05-21 v0.3.40 [dev] Adding `ShowDemoz` as a means to showcase quick env use of `Rails.application.credentials`
2024-05-20 v0.3.39 [dev] still fixing demo02 on UI = still not finished. dammit.
2024-05-20 v0.3.38 [dev] Fixed demo02 RAG in UI. Plus added meaningful_response.
2024-05-19 v0.3.37 [OPS] Added PALM_API_KEY_GEMINI to deployment script. Should fix Amarone and `PalmLLM`
2024-05-19 v0.3.36 [DEV] Added Amarone story to homepage, from PalmLLM which doesnt seem to work there.
2024-05-19 v0.3.35 [DEV] (untested) better UTF-8 **sanitization** in my tool `Langchain::Tool::ArticleTool`
2024-05-19 v0.3.34 [DEV] Demo02 is now rock solid
2024-05-19 v0.3.33 [DEV] Better description of Embeddings
2024-05-19 v0.3.32 [DEV] Demo1 being written in code and adding ThatsABingo easter egg for demo1
2024-05-18 v0.3.31 [DEV] Demo3 Newsretriever works
2024-05-18 v0.3.30 [DEV] Adding route and skeleton for demo-news-retriever
2024-05-18 v0.3.29 [DEV] Finally merged Stats! Plus added GEMINI_KEY2_SOLO_PER_GEMINEWS to both dev and prod
2024-05-18 v0.3.28 [DEV] Taking the LLM bull by their horns
2024-05-18 v0.3.27 [DEV] Seby bday! Rispolverated Palm to summarize..
2024-05-17 v0.3.26 [DEV] Added PROJECT_ID to the container
2024-05-17 v0.3.25 [DEV] Better caching
2024-05-17 v0.3.24 [DEV] Testing triptic demo4 - wow both gemini and vertex.
2024-05-17 v0.3.23 [DEV] Implementing Neha @authorizer authentication in both.
2024-05-17 v0.3.22 [DEV] Checking if moneky patching order DOES matter before my riccardo LLM initializer.
2024-05-16 v0.3.21 [DEV] Testing better caching of Articles.
2024-05-16 v0.3.20 [DEV] NewsRetriever is now getting keys from internal encrypted file, not from ENV.
2024-05-16 v0.3.19 [OPS] Moving Mem from 2gb to 3gb
2024-05-16 v0.3.18 [DEV] Testing Neha fix.
2024-05-16 v0.3.17 [DEV] Testing Neha fix.
2024-05-15 v0.3.16 [OPS] Added NewsRetriever so i can troubleshoot without LLMs.
                         Also added Gemini key to secret creds file.
2024-05-15 v0.3.15 [OPS] Added NewsAPI Key since i only had it in local but not in prod! Now Gemini is working great so this is the last part missing!
2024-05-15 v0.3.14 [DEV] Cleand up UX in Assistant page.
2024-05-15 v0.3.13 [DEV] 🍏 Making it work on Mac without changing Andrei's library.
2024-05-15 v0.3.12 [DEV] Super fast UI! removed latest article..
2024-05-15 v0.3.11 [DEV] adding demo for UI
2024-05-15 v0.3.10 [DEV] bugfix - remove console from dev.rb
2024-05-15 v0.3.9 [DEV] Adding `GoogleGeminiMessage.to_s` monkeypatching. Andrei will be proud.
2024-05-15 v0.3.8 [DEV] the tool works like a charm!
2024-05-15 v0.3.7 [DEV] FINALLY the Assistant works! Most work is outside of here, but just saying. Now fixing small stuff
                        like the baility of my tool function  to save an Article without breaking Ref Integrity.
2024-05-15 v0.3.6 [DEV] fixing Gemini auth. Dangerously patching local gemini.
2024-05-15 v0.3.5 [OPS] Fixed some derek/macbook differences.. not so visible to you but yes to me.
2024-05-15 v0.3.4 [DEV] Integrated with latest Langchain 0.13 with Gemini (woohoo!). Introducing GeminiAuthenticated
2024-05-14 v0.3.3 [DEV] Better links and docs
2024-05-14 v0.3.2 [DEV] Cleaned up bad/empty articles. Also made sure than now published_date is NEEDED field.
2024-05-14 v0.3.1 [DEV] Harmonized the new ArticleEmbedding is calculated correctly BOTH in the migration script `aaa`
                        AND in the migration v1 script (`compute_embeddings!`)
2024-05-14 v0.3.0 [DEV] Added DelayedJob (changed schema). Also added Description to rhe 3 Article Embeddings. Now I'll use ArticleEmbedding for Gemini stuff because Nearesdt Neighbor doesnt work across models :/
2024-05-14 v0.2.9 [DEV] Added SmartQueries. Also adding langhcianrb gem which BREAKs my Mac development but hopefully not my linux dev.
                        # Breaks on Mac, works on Linux
2024-05-14 v0.2.8 [DEV] Added RECENCY. Now visualizes only articles from last 48h
2024-05-14 v0.2.7 [DEV] Fixed graphs. Better similar articles now with title and author.
2024-05-13 v0.2.6 [DEV] Added distance to top close articles
2024-05-13 v0.2.5 [DEV] Fixed bug of `db:seed`
2024-05-12 v0.2.4 [DEV] Fixed bug of Embeddings! Now I have 3 embeddings which work.
2024-05-12 v0.2.3 [DEV] Added the first Chartkick graph.
2024-05-12 v0.2.2 [DEV] Adding graphs and minor things.
2024-04-19 v0.2.1 [DEV] Added BUCKET_NAME to Dockerfile
2024-04-18 v0.2.0 [DEV] Fixed schema from ARRAY error in `schema.rb`
2024-04-18 v0.1.7 [DEV] Fixed a bug in prod which made /Articles invisible/buggy when you dont have all embeddings.
                        Should test with no embeddings to make sure it works :)
2024-04-18 v0.1.7 [DEV] I fixed RAILS_ENV=production in localhost! Lets see if this change the build in Cloud Run!
2024-04-16 v0.1.5 [DEV] Now calculating embeddings as before_save with `resuce nil` to be safe.
2024-04-16 v0.1.4 [DEV] Relaxed the need for the JSON key there. So Cloud Build can keep building it.
2024-04-16 v0.1.3 [DEV] Finally vector and embeddings WORK in dev! Woohoo! I just needed to do some manual migration in dev.
2024-04-16 v0.1.2 [DEV] Adding 5 similar (while Im calculating embedding for 10k DEV articles)
2024-04-16 v0.1.1 [DEV] Added EmbeddingEmoji
2024-04-16 v0.1.0 [DEV] Added Embeddings for Title and Summary. Schema change.
2024-04-07 v0.34 [DEV] GCP Envs in encrypted master key stuff. Both prod and dev.
2024-04-07 v0.33 [DEV] First GCP working stuff. It will give me plenty of deployment headaches, I know already
2024-04-07 v0.32 [DEV] (before Vegas) Added GCP page, and /statusz endpoint. Also started IAP work for the future. Added cute logo.
2024-04-05 v0.31 [DEV] Fixed appname
2024-04-05 v0.30 [DEV] Started button above. Will fix on the plane.
2024-04-05 v0.29 [DEV] Caching articles in DEV. Its so fast now!!
2024-04-03 v0.28 [DEV] testing cache for latest article
2024-04-03 v0.27 [OPS] fixing generic script for PROD. I wasnt setting the DB PROD url.
2024-04-03 v0.26 [OPS] restored stricter cloud build [San Riccardo!]
...
2024-04-02 v0.23 [DEV] Added latest freshest news to HEADER - wOOOt
2024-04-02 v0.24 [OPS] Fixed hosts
2024-04-01 v0.23 [OPS] Restored CB linear - all steps yessir
2024-04-01 v0.22 [OPS] Now PROD and DEV are 4 whether its magic or not. Not magic = old
2024-04-01 v0.21 [DEV] Floating purple 10 articles now looks GREAT
2024-04-01 v0.20 [DEV] Update category helper method for link_to in view
