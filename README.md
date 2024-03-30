
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
## TODOs

* `rails-which-javascript-env ` should say ESBUILD since i installed it with it :)
