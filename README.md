
## INSTALL

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

## PROD

Apps are on Cloud Run

* DEV: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/pages/stats
* PROD: TODO


## TODOs

* `rails-which-javascript-env ` should say ESBUILD since i installed it with it :)
