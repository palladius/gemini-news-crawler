# 4 Demos

1. [UI/console] Embeddings and proximity query.
2. [UI/console] RAG
3. [UI best] NewsRetriever from LangchainRB (and page reconstruction). Nicer on UI as you see the images of articles.
4. [console best] Talk  Langchain assistant to retrieve latest news about X, tell you more about article Y and possibly save
   that article. And finally, a surprise.

## CLI + Rails Console

All demos can be played from the folder `docs/demo` in this way:

💻 Command line:

```
cd webapp/ # Go into rails folder
rails c  # opens console
```

Code: within 🚊💻 Rails Console:  https://github.com/palladius/gemini-news-crawler/blob/main/webapp/docs/demo/demo0X-rails-console.rb (with X=1,2,3,4)

You can also invoke them with `make demo01` .. `make demo04`.

**Note**. The most complex demo (`demo04`) is worth playing from CLI in non-deterministic way. You don't necessarily want to save the first article, and you might have a full conversation with the agent. Unfortunately I didn't have time to make this in responsive and sleek javascript, so the best experience is from `rails console`.

# Demo 1 - Article / Embeddings

## 🧠🧐 About

[[https://github.com/username/repository/blob/master/img/octocat.png|alt=octocat]]

![Demo 1: embeddings and neighbour gem](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo1.png?raw=true "Demo 1: Embeddings")



UI: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/articles/10350?easter_egg=bingo (note: article ID might change)

In this demo we want to demonstrate the ability for Ruby on Rails + PostgreS to easily host.

Lesson learnt: embeddings are BIG, and they slow significantly ActiveRecord retrievals.
Once you marry one embedding (I have 3 per article, 768 integers for each), you need to learn how to selectively `SELECT(:field1, :field2)` for the queries you do. For articles, that brought my time from 6 seconds to 50ms. 😱

Code: within 🚊💻 Rails Console:  https://github.com/palladius/gemini-news-crawler/blob/main/webapp/docs/demo/demo01-rails-console.rb

# Demo 2: RAG

![Demo 2A: Getting 5 closest articles by embedding(query)](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo2a.png?raw=true "Demo 2A: Getting 5 closest articles by embedding(query)")

![Demo 2B: Gemini summarizing the content](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo2b.png?raw=true "Demo 2B: Gemini summarizing the content")

### RAG Flow of consciouness from console


![RAG: A1 Short Prompt - instructions](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo02-pt1-short-prompt.png?raw=true "RAG pt1")

![RAG: A2 Long Prompt - articles excerpts](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo02-pt2-long-prompt.png?raw=true "RAG pt2")

![RAG: G Result - summary](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo02-pt3-summary.png?raw=true "RAG pt3")



# Demo 3: NewsRetriever from LangchainRB.

This works a lot better in UI, since it has images.

![Demo 3: NewsRetriever](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo3.png?raw=true "Demo 3: Get news online")


# Demo 4

Part 1: interaction with assistant (UI)

![Demo 4: Assistant Conversation](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo4a.png?raw=true "Demo 4: Assistant Conversation")

Part 2: See the article effectively saved in the DB. (UI)

![Demo 4: Selected article is actually saved on ActiveRecord](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo4b.png?raw=true "Demo 4: Selected article is actually saved on ActiveRecord")

Some samples on CLI:

![Demo 4 (CLI): see the system trying to save TWO articles and correctly reporting 1 success and 1 error](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/demo/demo4cli-b.png?raw=true "Demo 4 (CLI): see the system trying to save TWO articles and correctly reporting 1 success and 1 error")



# Conclusions

![A demo cant be considered complete without a Tarantino meme](https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/assets/images/thats-a-bingo.gif?raw=true "Ooh thats a bingo!")
