
# About ♊️ GemiNews 📰

Self: [palladius/gemini-news-crawler](https://github.com/palladius/gemini-news-crawler) (public)

This is a News Slurper that takes News in real time and - hopefully - feeds an LLM with RAG knowledge.

* Session: https://sessionize.com/app/speaker/session/621013
* Slides: [Ricc Slides](https://docs.google.com/presentation/d/11R5TbqPRsdeMdqN_1vFRS9v7qFRvOvpxTAFPOd-kfaE/edit#slide=id.g259ddd8dc87_0_2049)

Apps are on Cloud Run:

* DEV: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/
* PROD: [🫀 health check PROD](https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/up)

## Description

How can we get an LLM to be updated to today’s news?
Gen AI is great at answering questions.. from the past. After the LLM was trained, all you can do is RAG.
How about crawling the web for latest news with Gemini for multimodal extraction and offering summarization by your favorite topic?
It all gets more exciting thanks to Andrei’s langchainrb gem.

## Features

* [hot] **Gemini function calling** tools:
    * `NewsRetriever`: getting News from online (part of `langchainrb` gem),
    * `ArticleTool`: and from Active Record (local under `webapp/app/tools/article_tool.json`).
* Use `langchainrb` gem for Tools, Prompts, AI services (mostly Google ones).

![App Architecture](https://github.com/palladius/gemini-news-crawler/blob/main/docs/GeminewsArchitecture.png?raw=true "Architecture")

## Demos

4 juicy demos are available under `webapp/docs/demo/`:

https://github.com/palladius/gemini-news-crawler/blob/main/webapp/docs/demo/DEMO.md

## Other Ideas

My idea is to bring slides and a demo, all done in ruby leveraging nokogiri, langchainrb and possibly some capabilities in Langchainrb that Andrei is now building (*).

Slides: explain the overall idea, empathise with audience, show architecture diagram, why we’re here, and make people laugh.

My idea is to build a demo in two parts:

* A crawler which crawls a few sample web pages, extract information using Gen AI to understand if they’re pertinent to certain topics (eg music, sport, politics, ..) and extract other information (eg Location).

* Then, RAG-style, I’d feed an LLM and ask questions real time hoping to be able to surprise people with last-week news about different news sections. Like:
“How are presidential elections going? What’s the latest news?”
What’s latest with the ruby community? .. hoping to retrieve very latest news.

Possibly, retrieve similar pictures/articles based on the questions (embedding style).

* P2. **AWESOME**. Add a research by embedding. Something like "Search something about fun sport" and it calculates the embedding of "fun sport" and returns 5 closest articles. this means creating and declaring one more function.


## App info

### TODOs

* add `Devise` for user mgmt
* add `Cloud Run IAP`: https://blog.cloud66.com/authenticating_users_with_google_iap_in_rails
* Auto feed continuously. Currently manually done on my local machine :(
* Use updated Gemini embedding models, new since May 14th (launched at NEXT ‘24).
    * `text-embedding-004`
    * `text-multilingual-embedding-002`.

### Autofeed now

1. `cd crawler/ ; $ make crawl-a-lot` or `make crawl-continuously`. This populates XML every 15min (or I get kicked out by the robots :P ) and slurps articles from XML. XML I check on git, articles i dont or theyre too many.
2. `cd webapp ; bundle exec make seed-forever` (without bundle wont work). this seeds info from (1) into ActiveRecord, hence DB.
3. call an async routing to populate - although since v0.1.5 this should happen automatically before save of Article.
4. This workED: `cd webapp ; echo Article.compute_embeddings_for_all | rails c`. Note: since I moved from Array to Vector this script is now BROKEN

* Created secret: `projects/272932496670/secrets/geminews-key`
* Mounted on Crun as /geminews-key/geminews-key
* Now the final bit: GCP_KEY_PATH_FROM_WEBAPP = /geminews-key/geminews-key

