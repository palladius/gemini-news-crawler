
# Demo 1 - Article / Embeddings

## 🧠🧐 About

UI: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/articles/10350?easter_egg=bingo (note: article ID might change)

In this demo we want to demonstrate the ability for Ruby on Rails + PostgreS to easily host.

Lesson learnt: embeddings are BIG, and they slow significantly ActiveRecord retrievals.
Once you marry one embedding (I have 3 per article, 768 integers for each), you need to learn how to selectively `SELECT(:field1, :field2)` for the queries you do. For articles, that brought my time from 6 seconds to 50ms. 😱

## CLI + Rails Console

💻 Command line:

```
cd webapp/ # Go into rails folder
rails c  # opens console
```

Within 🚊💻 Rails Console:

```

```

# Demo 2



# Demo 3



# Demo 4

