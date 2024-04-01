
# About

This is a News Slurper that takes News in real time and - hopefully - feeds an LLM with RAG knowledge.


## PROD

Apps are on Cloud Run

* DEV: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/pages/stats
* PROD: TODO


## esbuild issues

This didnt work:
* `rails-ric webapp`
* this didnt work. Will do again with tailwind but without esbuild
* rails new "$1" -j esbuild --css tailwind

Lets try a second time🧮

```bash
rails new webapp --database=postgresql --css tailwind
rm -rf webapp/.git
git add webapp
```

* `rails-which-javascript-env ` should say ESBUILD since i installed it with it :)
