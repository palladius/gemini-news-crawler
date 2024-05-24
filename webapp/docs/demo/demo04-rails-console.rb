# This demo is a lot better run in the console than on web, given its interactive aspect.

# Nice visualizer for the chat -> moved to riccardo05_monkeypatch
# Nice patch of assistant: moved to `webapp/config/initializers/riccardo15_monkeypatch_langchain_assistant.rb`

#@query ||= 'Latest 5 news from Italy'

# llm = Langchain::LLM::GoogleVertexAI.new(project_id: ENV["GOOGLE_VERTEX_AI_PROJECT_ID"], region: "us-central1")

#llm = VertexLLM # doesnt work
#llm = GeminiLLM # TODO - move to above

llm  = Langchain::LLM::GoogleGemini.new(api_key: Rails.application.credentials.env.GEMINI_API_KEY_BIG_QUOTA)# rescue nil # 9xhQ

# thread = Langchain::Thread.new

# Creating tools to feed the Assistant
#news_retriever  = NewsRetriever # instantiated in config/initializers/
#article_tool = ArticleTool.new  # doing now


@assistant = Langchain::Assistant.new(
  llm: llm,
  thread: Langchain::Thread.new,
  instructions: "You are a News Assistant.",
  #instructions: "You are a News Assistant. When prompted for further info about some news, dont call further functions; instead show the JSON of the matching article - if there's one.",
  tools: [
    NewsRetriever,     # instantiated in config/initializers/
    ArticleTool.new ,  # instantiating now
  ]
)

# returns an array of messages -> adding nil or output is ugly.
#@assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true) ; nil
puts(@assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true))
#puts(thread.messages)
@assistant.history

@assistant.say 'how many results did the API call return?'
# 🤖 [model] 💬 The API call returned 34 results.

# Now its time to improvise a bit. Ask an additional question..
@assistant.say 'Tell me more about the asian news'
# @asistant.history
@assistant.say 'Save this the first two articles please'
@assistant.history
# Provides with the Cloud Run app url.
@assistant.say 'Thanks. Provide me with the Carlessian URL for the article you just saved please'

@assistant.say 'Save this the LAST two articles please'

# interact directly
@assistant.user_loop

#####################################################
# Sample output:
#####################################################
# irb(main):049> @assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true) ; nil
# irb(main):050>
# I, [2024-05-23T18:09:21.719098 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-23T18:09:25.308943 #783699]  INFO -- : [Langchain.rb] [Langchain::Tool::NewsRetriever]: Retrieving top news headlines
# I, [2024-05-23T18:09:25.467976 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# => nil
# irb(main):051> @assistant.history
# irb(main):052>
# 🧑 [user] 💬 Latest 5 news from Italy
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_top_headlines", "args"=>{"page_size"=>5, "country"=>"it"}}
# 🔢➡️🔢 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"AGI - Agenzia Italia","title":"Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia","description":null,"url":"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL9IBamh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL2FtcC8?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:34:26Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Sport Mediaset","title":"Oaktree, Alejandro Cano: \"Impegnati per successo a lungo termine dell'Inter\" - Sportmediaset - Sport Mediaset","description":null,"url":"https://news.google.com/rss/articles/CBMikgFodHRwczovL3d3dy5zcG9ydG1lZGlhc2V0Lm1lZGlhc2V0Lml0L2NhbGNpby9pbnRlci9vYWt0cmVlLWFsZWphbmRyby1jYW5vLWltcGVnbmF0aS1wZXItc3VjY2Vzc28tYS1sdW5nby10ZXJtaW5lLWRlbGwtaW50ZXJfODI1Nzc2MTYtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNTc3NjE2?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:30:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"TGCOM","title":"Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM","description":null,"url":"https://news.google.com/rss/articles/CBMifGh0dHBzOi8vd3d3LnRnY29tMjQubWVkaWFzZXQuaXQvY3JvbmFjYS92aWxsYXNhbHRvLXN1ZC1zYXJkZWduYS1mdWNpbGUtcGFkcmUtcGFydGUtY29scG8tbXVvcmUtMTdlbm5lXzgyNTkzNTcxLTIwMjQwMmsuc2h0bWzSAThodHRwczovL2FtcC50Z2NvbTI0Lm1lZGlhc2V0Lml0L3RnY29tMjQvYXJ0aWNsZS84MjU5MzU3MQ?oc=5","urlToImage":null,"publishedAt":"2024-05-22T15:30:28Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"ilmessaggero.it","title":"Iran, Khamenei incontra il leader di Hamas Haniyeh: «La promessa di eliminare Israele sarà mantenuta» - ilmessaggero.it","description":null,"url":"https://news.google.com/rss/articles/CBMinwFodHRwczovL3d3dy5pbG1lc3NhZ2dlcm8uaXQvbW9uZG8vaXJhbl9mdW5lcmFsaV9yYWlzaV9raGFtZW5laV9pbmNvbnRyYV9sZWFkZXJfaGFtYXNfcHJvbWVzc2FfZWxpbWluYXJlX2lzcmFlbGVfc2FyYV9tYW50ZW51dGFfY29zYV9zdGFfc3VjY2VkZW5kby04MTMzNTA3Lmh0bWzSAaMBaHR0cHM6Ly93d3cuaWxtZXNzYWdnZXJvLml0L0FNUC9tb25kby9pcmFuX2Z1bmVyYWxpX3JhaXNpX2toYW1lbmVpX2luY29udHJhX2xlYWRlcl9oYW1hc19wcm9tZXNzYV9lbGltaW5hcmVfaXNyYWVsZV9zYXJhX21hbnRlbnV0YV9jb3NhX3N0YV9zdWNjZWRlbmRvLTgxMzM1MDcuaHRtbA?oc=5","urlToImage":null,"publishedAt":"2024-05-22T14:51:41Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMizAFodHRwczovL3d3dy5jb3.. (🤥 redacted)
# 🤖 [model] 💬 Here are the latest 5 news from Italy:

# * Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia
# * Oaktree, Alejandro Cano: "Impegnati per successo a lungo termine dell'Inter" - Sportmediaset - Sport Mediaset
# * Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM
# * Iran, Khamenei incontra il leader di Hamas Haniyeh: ‘La promessa di eliminare Israele sarà mantenuta’ - ilmessaggero.it
# * Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera
# 🧑 [user] 💬 Latest 5 news from Italy
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_top_headlines", "args"=>{"page_size"=>5, "country"=>"it"}}
# 🔢➡️🔢 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"AGI - Agenzia Italia","title":"Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia","description":null,"url":"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL9IBamh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL2FtcC8?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:34:26Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Sport Mediaset","title":"Oaktree, Alejandro Cano: \"Impegnati per successo a lungo termine dell'Inter\" - Sportmediaset - Sport Mediaset","description":null,"url":"https://news.google.com/rss/articles/CBMikgFodHRwczovL3d3dy5zcG9ydG1lZGlhc2V0Lm1lZGlhc2V0Lml0L2NhbGNpby9pbnRlci9vYWt0cmVlLWFsZWphbmRyby1jYW5vLWltcGVnbmF0aS1wZXItc3VjY2Vzc28tYS1sdW5nby10ZXJtaW5lLWRlbGwtaW50ZXJfODI1Nzc2MTYtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNTc3NjE2?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:30:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"TGCOM","title":"Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM","description":null,"url":"https://news.google.com/rss/articles/CBMifGh0dHBzOi8vd3d3LnRnY29tMjQubWVkaWFzZXQuaXQvY3JvbmFjYS92aWxsYXNhbHRvLXN1ZC1zYXJkZWduYS1mdWNpbGUtcGFkcmUtcGFydGUtY29scG8tbXVvcmUtMTdlbm5lXzgyNTkzNTcxLTIwMjQwMmsuc2h0bWzSAThodHRwczovL2FtcC50Z2NvbTI0Lm1lZGlhc2V0Lml0L3RnY29tMjQvYXJ0aWNsZS84MjU5MzU3MQ?oc=5","urlToImage":null,"publishedAt":"2024-05-22T15:30:28Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"ilmessaggero.it","title":"Iran, Khamenei incontra il leader di Hamas Haniyeh: «La promessa di eliminare Israele sarà mantenuta» - ilmessaggero.it","description":null,"url":"https://news.google.com/rss/articles/CBMinwFodHRwczovL3d3dy5pbG1lc3NhZ2dlcm8uaXQvbW9uZG8vaXJhbl9mdW5lcmFsaV9yYWlzaV9raGFtZW5laV9pbmNvbnRyYV9sZWFkZXJfaGFtYXNfcHJvbWVzc2FfZWxpbWluYXJlX2lzcmFlbGVfc2FyYV9tYW50ZW51dGFfY29zYV9zdGFfc3VjY2VkZW5kby04MTMzNTA3Lmh0bWzSAaMBaHR0cHM6Ly93d3cuaWxtZXNzYWdnZXJvLml0L0FNUC9tb25kby9pcmFuX2Z1bmVyYWxpX3JhaXNpX2toYW1lbmVpX2luY29udHJhX2xlYWRlcl9oYW1hc19wcm9tZXNzYV9lbGltaW5hcmVfaXNyYWVsZV9zYXJhX21hbnRlbnV0YV9jb3NhX3N0YV9zdWNjZWRlbmRvLTgxMzM1MDcuaHRtbA?oc=5","urlToImage":null,"publishedAt":"2024-05-22T14:51:41Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMizAFodHRwczovL3d3dy5jb3.. (🤥 redacted)
# 🤖 [model] 💬 Here are the latest 5 news from Italy:

# * Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia
# * Oaktree, Alejandro Cano: "Impegnati per successo a lungo termine dell'Inter" - Sportmediaset - Sport Mediaset
# * Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM
# * Iran, Khamenei incontra il leader di Hamas Haniyeh: ‘La promessa di eliminare Israele sarà mantenuta’ - ilmessaggero.it
# * Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera
# => nil
# irb(main):053> puts(@assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true))
# I, [2024-05-23T18:09:55.927659 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-23T18:09:58.721224 #783699]  INFO -- : [Langchain.rb] [Langchain::Tool::NewsRetriever]: Retrieving top news headlines
# I, [2024-05-23T18:09:58.870391 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🧑 [user] 💬 Latest 5 news from Italy
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_top_headlines", "args"=>{"page_size"=>5, "country"=>"it"}}
# 🔢➡️🔢 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"AGI - Agenzia Italia","title":"Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia","description":null,"url":"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL9IBamh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL2FtcC8?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:34:26Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Sport Mediaset","title":"Oaktree, Alejandro Cano: \"Impegnati per successo a lungo termine dell'Inter\" - Sportmediaset - Sport Mediaset","description":null,"url":"https://news.google.com/rss/articles/CBMikgFodHRwczovL3d3dy5zcG9ydG1lZGlhc2V0Lm1lZGlhc2V0Lml0L2NhbGNpby9pbnRlci9vYWt0cmVlLWFsZWphbmRyby1jYW5vLWltcGVnbmF0aS1wZXItc3VjY2Vzc28tYS1sdW5nby10ZXJtaW5lLWRlbGwtaW50ZXJfODI1Nzc2MTYtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNTc3NjE2?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:30:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"TGCOM","title":"Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM","description":null,"url":"https://news.google.com/rss/articles/CBMifGh0dHBzOi8vd3d3LnRnY29tMjQubWVkaWFzZXQuaXQvY3JvbmFjYS92aWxsYXNhbHRvLXN1ZC1zYXJkZWduYS1mdWNpbGUtcGFkcmUtcGFydGUtY29scG8tbXVvcmUtMTdlbm5lXzgyNTkzNTcxLTIwMjQwMmsuc2h0bWzSAThodHRwczovL2FtcC50Z2NvbTI0Lm1lZGlhc2V0Lml0L3RnY29tMjQvYXJ0aWNsZS84MjU5MzU3MQ?oc=5","urlToImage":null,"publishedAt":"2024-05-22T15:30:28Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"ilmessaggero.it","title":"Iran, Khamenei incontra il leader di Hamas Haniyeh: «La promessa di eliminare Israele sarà mantenuta» - ilmessaggero.it","description":null,"url":"https://news.google.com/rss/articles/CBMinwFodHRwczovL3d3dy5pbG1lc3NhZ2dlcm8uaXQvbW9uZG8vaXJhbl9mdW5lcmFsaV9yYWlzaV9raGFtZW5laV9pbmNvbnRyYV9sZWFkZXJfaGFtYXNfcHJvbWVzc2FfZWxpbWluYXJlX2lzcmFlbGVfc2FyYV9tYW50ZW51dGFfY29zYV9zdGFfc3VjY2VkZW5kby04MTMzNTA3Lmh0bWzSAaMBaHR0cHM6Ly93d3cuaWxtZXNzYWdnZXJvLml0L0FNUC9tb25kby9pcmFuX2Z1bmVyYWxpX3JhaXNpX2toYW1lbmVpX2luY29udHJhX2xlYWRlcl9oYW1hc19wcm9tZXNzYV9lbGltaW5hcmVfaXNyYWVsZV9zYXJhX21hbnRlbnV0YV9jb3NhX3N0YV9zdWNjZWRlbmRvLTgxMzM1MDcuaHRtbA?oc=5","urlToImage":null,"publishedAt":"2024-05-22T14:51:41Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMizAFodHRwczovL3d3dy5jb3.. (🤥 redacted)
# 🤖 [model] 💬 Here are the latest 5 news from Italy:

# * Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia
# * Oaktree, Alejandro Cano: "Impegnati per successo a lungo termine dell'Inter" - Sportmediaset - Sport Mediaset
# * Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM
# * Iran, Khamenei incontra il leader di Hamas Haniyeh: ‘La promessa di eliminare Israele sarà mantenuta’ - ilmessaggero.it
# * Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera
# 🧑 [user] 💬 Latest 5 news from Italy
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_top_headlines", "args"=>{"page_size"=>5, "country"=>"it"}}
# 🔢➡️🔢 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"AGI - Agenzia Italia","title":"Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia","description":null,"url":"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL9IBamh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL2FtcC8?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:34:26Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Sport Mediaset","title":"Oaktree, Alejandro Cano: \"Impegnati per successo a lungo termine dell'Inter\" - Sportmediaset - Sport Mediaset","description":null,"url":"https://news.google.com/rss/articles/CBMikgFodHRwczovL3d3dy5zcG9ydG1lZGlhc2V0Lm1lZGlhc2V0Lml0L2NhbGNpby9pbnRlci9vYWt0cmVlLWFsZWphbmRyby1jYW5vLWltcGVnbmF0aS1wZXItc3VjY2Vzc28tYS1sdW5nby10ZXJtaW5lLWRlbGwtaW50ZXJfODI1Nzc2MTYtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNTc3NjE2?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:30:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"TGCOM","title":"Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM","description":null,"url":"https://news.google.com/rss/articles/CBMifGh0dHBzOi8vd3d3LnRnY29tMjQubWVkaWFzZXQuaXQvY3JvbmFjYS92aWxsYXNhbHRvLXN1ZC1zYXJkZWduYS1mdWNpbGUtcGFkcmUtcGFydGUtY29scG8tbXVvcmUtMTdlbm5lXzgyNTkzNTcxLTIwMjQwMmsuc2h0bWzSAThodHRwczovL2FtcC50Z2NvbTI0Lm1lZGlhc2V0Lml0L3RnY29tMjQvYXJ0aWNsZS84MjU5MzU3MQ?oc=5","urlToImage":null,"publishedAt":"2024-05-22T15:30:28Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"ilmessaggero.it","title":"Iran, Khamenei incontra il leader di Hamas Haniyeh: «La promessa di eliminare Israele sarà mantenuta» - ilmessaggero.it","description":null,"url":"https://news.google.com/rss/articles/CBMinwFodHRwczovL3d3dy5pbG1lc3NhZ2dlcm8uaXQvbW9uZG8vaXJhbl9mdW5lcmFsaV9yYWlzaV9raGFtZW5laV9pbmNvbnRyYV9sZWFkZXJfaGFtYXNfcHJvbWVzc2FfZWxpbWluYXJlX2lzcmFlbGVfc2FyYV9tYW50ZW51dGFfY29zYV9zdGFfc3VjY2VkZW5kby04MTMzNTA3Lmh0bWzSAaMBaHR0cHM6Ly93d3cuaWxtZXNzYWdnZXJvLml0L0FNUC9tb25kby9pcmFuX2Z1bmVyYWxpX3JhaXNpX2toYW1lbmVpX2luY29udHJhX2xlYWRlcl9oYW1hc19wcm9tZXNzYV9lbGltaW5hcmVfaXNyYWVsZV9zYXJhX21hbnRlbnV0YV9jb3NhX3N0YV9zdWNjZWRlbmRvLTgxMzM1MDcuaHRtbA?oc=5","urlToImage":null,"publishedAt":"2024-05-22T14:51:41Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMizAFodHRwczovL3d3dy5jb3.. (🤥 redacted)
# 🤖 [model] 💬 Here are the latest 5 news from Italy:

# * Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia
# * Oaktree, Alejandro Cano: "Impegnati per successo a lungo termine dell'Inter" - Sportmediaset - Sport Mediaset
# * Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM
# * Iran, Khamenei incontra il leader di Hamas Haniyeh: ‘La promessa di eliminare Israele sarà mantenuta’ - ilmessaggero.it
# * Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera
# 🧑 [user] 💬 Latest 5 news from Italy
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_top_headlines", "args"=>{"page_size"=>5, "country"=>"it"}}
# 🔢➡️🔢 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"AGI - Agenzia Italia","title":"Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia","description":null,"url":"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL9IBamh0dHBzOi8vd3d3LmFnaS5pdC9jcm9uYWNhL25ld3MvMjAyNC0wNS0yMi9naWFsbG8taW5mbHVlbmNlci1zaXUtcmljb3ZlcmF0YS1ncmF2aS1jb25kaXppb25pLTI2NDg3NzQwL2FtcC8?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:34:26Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Sport Mediaset","title":"Oaktree, Alejandro Cano: \"Impegnati per successo a lungo termine dell'Inter\" - Sportmediaset - Sport Mediaset","description":null,"url":"https://news.google.com/rss/articles/CBMikgFodHRwczovL3d3dy5zcG9ydG1lZGlhc2V0Lm1lZGlhc2V0Lml0L2NhbGNpby9pbnRlci9vYWt0cmVlLWFsZWphbmRyby1jYW5vLWltcGVnbmF0aS1wZXItc3VjY2Vzc28tYS1sdW5nby10ZXJtaW5lLWRlbGwtaW50ZXJfODI1Nzc2MTYtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNTc3NjE2?oc=5","urlToImage":null,"publishedAt":"2024-05-22T16:30:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"TGCOM","title":"Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM","description":null,"url":"https://news.google.com/rss/articles/CBMifGh0dHBzOi8vd3d3LnRnY29tMjQubWVkaWFzZXQuaXQvY3JvbmFjYS92aWxsYXNhbHRvLXN1ZC1zYXJkZWduYS1mdWNpbGUtcGFkcmUtcGFydGUtY29scG8tbXVvcmUtMTdlbm5lXzgyNTkzNTcxLTIwMjQwMmsuc2h0bWzSAThodHRwczovL2FtcC50Z2NvbTI0Lm1lZGlhc2V0Lml0L3RnY29tMjQvYXJ0aWNsZS84MjU5MzU3MQ?oc=5","urlToImage":null,"publishedAt":"2024-05-22T15:30:28Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"ilmessaggero.it","title":"Iran, Khamenei incontra il leader di Hamas Haniyeh: «La promessa di eliminare Israele sarà mantenuta» - ilmessaggero.it","description":null,"url":"https://news.google.com/rss/articles/CBMinwFodHRwczovL3d3dy5pbG1lc3NhZ2dlcm8uaXQvbW9uZG8vaXJhbl9mdW5lcmFsaV9yYWlzaV9raGFtZW5laV9pbmNvbnRyYV9sZWFkZXJfaGFtYXNfcHJvbWVzc2FfZWxpbWluYXJlX2lzcmFlbGVfc2FyYV9tYW50ZW51dGFfY29zYV9zdGFfc3VjY2VkZW5kby04MTMzNTA3Lmh0bWzSAaMBaHR0cHM6Ly93d3cuaWxtZXNzYWdnZXJvLml0L0FNUC9tb25kby9pcmFuX2Z1bmVyYWxpX3JhaXNpX2toYW1lbmVpX2luY29udHJhX2xlYWRlcl9oYW1hc19wcm9tZXNzYV9lbGltaW5hcmVfaXNyYWVsZV9zYXJhX21hbnRlbnV0YV9jb3NhX3N0YV9zdWNjZWRlbmRvLTgxMzM1MDcuaHRtbA?oc=5","urlToImage":null,"publishedAt":"2024-05-22T14:51:41Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMizAFodHRwczovL3d3dy5jb3.. (🤥 redacted)
# 🤖 [model] 💬 Here are the latest 5 news from Italy:

# * Il giallo di Siu, l'influencer biellese ricoverata in fin di vita: c'è un indagato per tentato omicidio - AGI - Agenzia Italia
# * Oaktree, Alejandro Cano: "Impegnati per successo a lungo termine dell'Inter" - Sportmediaset - Sport Mediaset
# * Villasalto (Sud Sardegna), prende il fucile del padre e parte un colpo: muore 17enne - TGCOM
# * Iran, Khamenei incontra il leader di Hamas Haniyeh: ‘La promessa di eliminare Israele sarà mantenuta’ - ilmessaggero.it
# * Volo Londra-Singapore: 20 persone in terapia intensiva. Inchiesta sulla turbolenza che ha causato l'incidente - Corriere della Sera
# => nil
# irb(main):054> @assistant.say 'tell me more about the london singapore flight'
# I, [2024-05-23T18:10:19.279233 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-23T18:10:23.032310 #783699]  INFO -- : [Langchain.rb] [Langchain::Tool::NewsRetriever]: Retrieving all news
# I, [2024-05-23T18:10:23.204305 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🔢➡️🔢 [function] 🛠️  news_retriever__get_everything => {"status":"ok","totalResults":20,"articles":[{"source":{"id":"il-sole-24-ore","name":"Il Sole 24 Ore"},"author":null,"title":"Volo Singapore Airlines, le cause dell’incidente","description":"Come si è verificata la perdita di quota e perché","url":"https://www.ilsole24ore.com/art/volo-singapore-airlines-cause-dell-incidente-AGLrWtC","urlToImage":"https://i2.res.24o.it/images2010/S24/Documenti/2024/05/23/Immagini/Ritagli/lwgkqdtvvxt0pds9lr-U02233408804uQr-1440x752@IlSole24Ore-Web.jpg?r=1170x507","publishedAt":"2024-05-22T12:11:00Z","content":"Ascolta la versione audio dell'articolo\r\n2' di lettura\r\nSul volo della Singapore Airlines da Londra a Singapore costretto domenica a un atterraggio di emergenza a Bankok per una forte turbolenza, una… [+1351 chars]"},{"source":{"id":null,"name":"Ilfattoquotidiano.it"},"author":"F. Q.","title":"Singapore Airlines, morto un passeggero a causa di una turbolenza in aria chiara. Cos’è questo fenomeno e perché è così pericoloso?","description":"Sul volo da Londra a Singapore, una forte turbolenza ha causato un morto e 30 feriti\nL'articolo Singapore Airlines, morto un passeggero a causa di una turbolenza in aria chiara. Cos’è questo fenomeno e perché è così pericoloso? proviene da Il Fatto Quotidiano.","url":"https://www.ilfattoquotidiano.it/2024/05/21/singapore-airlines-morto-un-passeggero-a-causa-di-una-turbolenza-in-aria-chiara-cose-questo-fenomeno-e-perche-e-cosi-pericoloso/7556739/","urlToImage":"https://st.ilfattoquotidiano.it/wp-content/uploads/2024/05/21/singaporeaereo-1-1200x630.jpg","publishedAt":"2024-05-21T14:30:44Z","content":"Negli ultimi anni, i viaggi in aereo sono sempre più caratterizzati da scossone e turbolenze, soprattutto “in aria chiara”. Come riferito dall’ Independent, nell’ultimo volo da Londra Heathrow a Sing… [+1263 chars]"},{"source":{"id":null,"name":"Ilfattoquotidiano.it"},"author":"F. Q.","title":"Violenta turbolenza in alta quota per il volo Londra-Singapore: morto un passeggero, altri 30 feriti","description":"L'aereo è stato costretto a un atterraggio di emergenza all'aeroporto di Bangkok, in Thailandia\nL'articolo Violenta turbolenza in alta quota per il volo Londra-Singapore: morto un passeggero, altri 30 feriti proviene da Il Fatto Quotidiano.","url":"https://www.ilfattoquotidiano.it/2024/05/21/violenta-turbolenza-in-alta-quota-per-il-volo-londra-singapore-morto-un-passeggero-altri-30-feriti/7556426/","urlToImage":"https://st.ilfattoquotidiano.it/wp-content/uploads/2024/05/21/SQ321-dentro-aereo-1200x630.jpeg","publishedAt":"2024-05-21T11:33:12Z","content":"Un volo della Singapore Airlines, diretto da Londra a Singapore, è stato costretto a un atterraggio di emergenza all’aeroporto di Bangkok a causa di “gravi turbolenze” che hanno causato la morte di u… [+2282 chars]"},{"source":{"id":null,"name":"Ilfattoquotidiano.it"},"author":"F. Q.","title":"Turbolenza sul volo Singapore Airlines, 71 i feriti. Il racconto dei passeggeri: “Sembrava che l’aereo fosse caduto”","description.. (🤥 redacted)
# 🤖 [model] 💬 A Singapore Airlines flight from London to Singapore experienced severe turbulence on May 20, 2024, leading to the death of one passenger and injuring over 20 others. The pilots had to make an emergency landing in Bangkok.

# The turbulence, which lasted about six seconds, was described as "clear-air turbulence," a particularly dangerous type that occurs unexpectedly without visible weather warnings. Passengers reported feeling like the plane had dropped from the sky. One passenger sadly died, and 30 were initially reported injured, with that number later rising to 71.

# Investigations into the incident are ongoing.
# => nil
# irb(main):055> @assistant.say 'wow, can you please save this?'
# I, [2024-05-23T18:11:32.120409 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
#   TRANSACTION (35.1ms)  BEGIN
#   Article Exists? (76.2ms)  SELECT 1 AS one FROM "articles" WHERE "articles"."title" = $1 LIMIT $2  [["title", "Severe Turbulence on Singapore Airlines Flight Results in Fatality"], ["LIMIT", 1]]
#   Article Exists? (41.6ms)  SELECT 1 AS one FROM "articles" WHERE "articles"."guid" = $1 LIMIT $2  [["guid", "https://www.internazionale.it/ultime-notizie/2024/05/21/singapore-airlines-turbolenza"], ["LIMIT", 1]]
# @categories_to_be_initialized:
# Article before_save(): set_embeddings_best_effort()
# Some Embeddings are EMPTY - what I do is now needed!
# + Compute embeddings for a Article. Value: 'Severe Turbulence on Singapore Airlines Flight Results in Fatality'. Len=66
# ETHON: Libcurl initialized
# ETHON: performed EASY effective_url=https://us-central1-aiplatform.googleapis.com/v1/projects/palladius-genai/locations/us-central1/publishers/google/models/textembedding-gecko-multilingual:predict response_code=200 return_code=ok total_time=0.931767
# 📊 Stats: {"truncated"=>false, "token_count"=>13}
# 📊 cleaned_response (should be an Array) is a: Array
# ♊️ YAY! Gemini Embeddings responded with a 768-sized embedding: [0.012439343146979809, -0.015916937962174416, 0.049488577991724014], ...
# + Compute embeddings for a Article. Value: 'A Singapore Airlines flight from London to Singapore experienced severe turbulence, leading to one death and multiple injuries.'. Len=127
# ETHON: performed EASY effective_url=https://us-central1-aiplatform.googleapis.com/v1/projects/palladius-genai/locations/us-central1/publishers/google/models/textembedding-gecko-multilingual:predict response_code=200 return_code=ok total_time=0.236019
# 📊 Stats: {"truncated"=>false, "token_count"=>25}
# 📊 cleaned_response (should be an Array) is a: Array
# ♊️ YAY! Gemini Embeddings responded with a 768-sized embedding: [0.015322679653763771, -0.013846354559063911, 0.06667079031467438], ...
# Computing ArticleEmbeddings in v2!
# 🐒🐒🐒 Monkeypatching GoogleGemini::embed() and copying from Vertex on gem (ILLEGAL) 🐒🐒🐒
# 🐒🐒🐒 Monkeypatching GoogleGemini::neha_authenticate(): Cache HIT! 🐒🐒🐒
#   Article Exists? (38.8ms)  SELECT 1 AS one FROM "articles" WHERE "articles"."title" = $1 LIMIT $2  [["title", "Severe Turbulence on Singapore Airlines Flight Results in Fatality"], ["LIMIT", 1]]
#   Article Exists? (42.0ms)  SELECT 1 AS one FROM "articles" WHERE "articles"."guid" = $1 LIMIT $2  [["guid", "https://www.internazionale.it/ultime-notizie/2024/05/21/singapore-airlines-turbolenza"], ["LIMIT", 1]]
# @categories_to_be_initialized:
# Article before_save(): set_embeddings_best_effort()
# Some Embeddings are NON EMPTY - I skip all (but TBH I should be iterating through every value...)
# - 1. title_embedding.nil? -> false
# - 2. summary_embedding.nil? -> false
# - 3. article_embedding.nil? -> false
#   Article Create (107.6ms)  INSERT INTO "articles" ("title", "summary", "content", "author", "link", "published_date", "image_url", "feed_url", "guid", "hidden_blurb", "language", "active", "ricc_internal_notes", "ricc_source", "created_at", "updated_at", "newspaper", "macro_region", "title_embedding", "summary_embedding", "article_embedding", "title_embedding_description", "article_embedding_description", "summary_embedding_description") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24) RETURNING "id"  [["title", "Severe Turbulence on Singapore Airlines Flight Results in Fatality"], ["summary", "A Singapore Airlines flight from London to Singapore experienced severe turbulence, leading to one death and multiple injuries."], ["content", "A Singapore Airlines flight from London to Singapore experienced severe turbulence on May 20, 2024, leading to the death of one passenger and injuring over 20 others. The pilots had to make an emergency landing in Bangkok. \\n\\nThe turbulence, which lasted about six seconds, was described as 'clear-air turbulence,' a particularly dangerous type that occurs unexpectedly without visible weather warnings. Passengers reported feeling like the plane had dropped from the sky. One passenger sadly died, and 30 were initially reported injured, with that number later rising to 71. \\n\\nInvestigations into the incident are ongoing."], ["author", "Singapore Airlines"], ["link", "https://www.internazionale.it/ultime-notizie/2024/05/21/singapore-airlines-turbolenza"], ["published_date", "2024-05-21 15:02:28"], ["image_url", nil], ["feed_url", nil], ["guid", "https://www.internazionale.it/ultime-notizie/2024/05/21/singapore-airlines-turbolenza"], ["hidden_blurb", "{:country=>\"Vatican City\", :country_emoji=>\"🇻🇦\", :article_tool_version=>\"1.10\"}"], ["language", "en"], ["active", true], ["ricc_internal_notes", "Created through Andrei's amazing ArticleTool article_tool v1.10.\n        parsable_blurb = {\n          country: 'Vatican City',\n          country_emoji: '🇻🇦',\n        }\n      "], ["ricc_source", "Gemini FunctionCalling"], ["created_at", "2024-05-23 16:11:43.294694"], ["updated_at", "2024-05-23 16:11:43.294694"], ["newspaper", "www.internazionale.it"], ["macro_region", "gemini-fun-call"], ["title_embedding", "[0.012439343146979809, -0.015916937962174416, 0.049488577991724014, 0.03329973295331001, -0.07694598287343979, -0.06454874575138092, -0.011392675340175629, 0.01909843645 [..]
# 8752207532525]"], ["title_embedding_description", nil], ["article_embedding_description", "{:llm_project_id=>\"palladius-genai\", :llm_dimensions=>nil, :article_size=>1004, :llm_embeddings_model_name=>\"textembedding-gecko\"}"], ["summary_embedding_description", nil]]
# Article::set_defaults_after (after_save). My id=10372
# Article::set_defaults_after (after_save). My id=10372
#   TRANSACTION (36.8ms)  COMMIT
# I, [2024-05-23T18:11:43.451946 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🔢➡️🔢 [function] 🛠️  article_tool__create => {"id"=>10372, "title"=>"Severe Turbulence on Singapore Airlines Flight Results in Fatality", "summary"=>"A Singapore Airlines flight from London to Singapore experienced severe turbulence, leading to one death and multiple injuries.", "content"=>"A Singapore Airlines flight from London to Singapore experienced severe turbulence on May 20, 2024, leading to the death of one passenger and injuring over 20 others. The pilots had to make an emergency landing in Bangkok. \\n\\nThe turbulence, which lasted about six seconds, was described as 'clear-air turbulence,' a particularly dangerous type that occurs unexpectedly without visible weather warnings. Passengers reported feeling like the plane had dropped from the sky. One passenger sadly died, and 30 were initially reported injured, with that number later rising to 71. \\n\\nInvestigations into the incident are ongoing.", "author"=>"Singapore Airlines", "link"=>"https://www.internazionale.it/ultime-notizie/2024/05/21/singapore-airlines-turbolenza", "published_date"=>Tue, 21 May 2024 15:02:28.000000000 UTC +00:00, "image_url"=>nil, "feed_url"=>nil, "language"=>"en", "active"=>true, "ricc_source"=>"Gemini FunctionCalling", "created_at"=>Thu, 23 May 2024 16:11:43.294694000 UTC +00:00, "updated_at"=>Thu, 23 May 2024 16:11:43.294694000 UTC +00:00, "newspaper"=>"www.internazionale.it", "macro_region"=>"gemini-fun-call"}
# 🤖 [model] 💬 Ok, I've saved this news article for you.
# => nil
# irb(main):056> @assistant.say 'Thanks. Provide me with the Carlessian URL for the article you just saved please'
# irb(main):057>
# I, [2024-05-23T18:11:58.367824 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-23T18:12:02.747952 #783699]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🔢➡️🔢 [function] 🛠️  article_tool__carlessian_url => https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/articles/10372
# 🤖 [model] 💬 Here's the Carlessian URL for the saved article: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/articles/10372
