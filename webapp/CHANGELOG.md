## Open bugs

* b/101 NewsRetriever doesnt work on CloudRun. Cant seemt o find ENV. I'm considering using the builtin cryptic config instead.
* b/102 Doesnt work on GCE - yet. getting there thanks to Neha
* bad encoding http://localhost:3000/articles/10346. note \342\200\231 is a '!

## Changelog

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
