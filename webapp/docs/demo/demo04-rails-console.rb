# frozen_string_literal: true

# This demo is a lot better run in the console than on web, given its interactive aspect.
# Nice visualizer for the chat -> moved to riccardo05_monkeypatch
# Nice patch of assistant: moved to `webapp/config/initializers/riccardo15_monkeypatch_langchain_assistant.rb`

# llm = Langchain::LLM::GoogleVertexAI.new(project_id: ENV["GOOGLE_VERTEX_AI_PROJECT_ID"], region: "us-central1")
#Langchain.logger.level = Logger::ERROR


llm = Langchain::LLM::GoogleGemini.new(api_key: Rails.application.credentials.env.GEMINI_API_KEY_BIG_QUOTA) # rescue nil # 9xhQ
# Which model are we using?
llm.defaults[:chat_completion_model_name]
# => "gemini-1.5-pro-latest"



@assistant = Langchain::Assistant.new(
  llm: llm,
  #thread: Langchain::Thread.new,
  instructions: 'You are a News Assistant. When prompted about articles, make sure to always use numeric bullet points.',
  # You can iterate and program your assistant based on your preferences.
  # instructions: "You are a News Assistant. When prompted for further info about some news, dont call further functions; instead show the JSON of the matching article - if there's one.",
  tools: [
    NewsRetriever, # 🔧 instantiated in config/initializers/
    Langchain::Tool::RiccardoArticle.new # 🔧 instantiating now. Code in: https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/tools/article_tool.rb
  ]
)

def s(str) = @assistant.say(str)
# VERBOSE: puts(@assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true))
# SHORT:   s 'Latest 5 news from Italy'
############################################################################################################
# New 22aug24 - nice colorful expression of Gemini messages, where **markdown** is expressed in colors :)
def last_message = @assistant.thread.messages.last.content
def penultimate_message = @assistant.thread.messages[-2].content
def last_message_decoded = JSON.parse(last_message)
def penultimate_message_decoded = JSON.parse(penultimate_message)
def colorize_bold(text)
  regex = /\*\*\s*(.*?)\s*\*\*/
  result = text.gsub(regex) do |match|
    "\e[0;33m#{match.gsub(/\*\*/, '')}\e[0m"
  end
  puts(result) # instant gratification :)
  result
end
def colorful_lastmessage = colorize_bold(last_message)
def putlm = puts(colorful_lastmessage)
############################################################################################################
# enable HTTP in case its broken
# Net::HTTP.enable_debug!




# Bummer:  Italy, France, ... fails :/
s 'Latest 5 news from United States'

# s 'five more please'
# @assistant.history

s 'Get everything about Arrosticini'

s 'Im at a conference and my audience is quite susceptible, I want to avoid political or war topics. Which news would you choose to demonstrate this? Pick the least divisive please.'

s 'awesome! Save the 5th article on DB'

# returns an array of messages
@assistant.history

@assistant.say 'how many results did the API call return?'
# 🤖 [model] 💬 The API call returned 34 results.

s 'give me everything you have on arrosticini'
@assistant.say 'Save this the first two articles please'


# 🎉 New Pescara nov2024!! 🎉
s 'give me all Articles in the DB writen by Roberto Saviano'

# Now its time to improvise a bit. Ask an additional question..
#@assistant.say 'Tell me more about the asian news'
# @asistant.history
#@assistant.say 'Save this the first two articles please'
@assistant.history
# Provides with the Cloud Run app url.
@assistant.say 'Thanks. Provide me with the Carlessian URL and Local URL for the article you just saved please'

@assistant.say 'Save this the LAST two articles please'

# Very interesting for Modena
s 'Im at a conference and my audience is quite susceptible, I want to avoid political or war topics. Which news would you choose to demonstrate this? Pick the least divisive please.'


# Pescara v1
s 'give me news about Pescara'
s 'give me news about DevFest in Italian language'
s 'give me news about DevFest in any language'
s 'save the french articles to DB' # already done
# interact directly
@assistant.user_loop


# Pescara better, with "Get everything" which actually invokes Pescara
s 'get everything from Pescara'
s 'please save to the DB all articles which explicitly mention Pescara in the title'
#s 'get everything from Pescara, in English'
s 'get everything from Pescara where article is written in English'






























# Experiment
# got a japanes earticle thorugh get everything on devfest
# 🤖 [model] 💬 The Tokyo article has been saved.
s 'now trasnslate the Japanese article to Italian. Translate all content (title, author, language, ..) to Italian and change the link from .jp to .it. Preserve the rest. Save the result to DB'

















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

## Conversation about and then on Bologna - not a Sport one please :)

# Loading production environment (Rails 7.1.3.2)
# irb(main):001>
# irb(main):002> llm  = Langchain::LLM::GoogleGemini.new(api_key: Rails.application.credentials.env.GEMINI_API_KEY_BIG_QUOTA)# rescue nil # 9xhQ
# irb(main):003>
# irb(main):004> # Which model are we using?
# irb(main):005> llm.defaults[:chat_completion_model_name]
# irb(main):006> # => "gemini-1.5-pro-latest"
# irb(main):007>
# irb(main):008>
# irb(main):009* @assistant = Langchain::Assistant.new(
# irb(main):010*   llm: llm,
# irb(main):011*   thread: Langchain::Thread.new,
# irb(main):012*   instructions: "You are a News Assistant.",
# irb(main):013*   # You can iterate and program your assistant based on your preferences.
# irb(main):014*   #instructions: "You are a News Assistant. When prompted for further info about some news, dont call further functions; instead show the JSON of the matching article - if there's one.",
# irb(main):015*   tools: [
# irb(main):016*     NewsRetriever,     # instantiated in config/initializers/
# irb(main):017*     ArticleTool.new ,  # instantiating now
# irb(main):018*   ]
# irb(main):019> )
# irb(main):020>
# irb(main):021> def s(str); @assistant.say(str); end
# irb(main):022>
# irb(main):023> # returns an array of messages -> adding nil or output is ugly.
# irb(main):024> #@assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true) ; nil
# irb(main):025> puts(@assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true))
# I, [2024-05-25T10:19:36.022346 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-25T10:19:38.694700 #13812]  INFO -- : [Langchain.rb] [Langchain::Tool::NewsRetriever]: Retrieving top news headlines
# I, [2024-05-25T10:19:39.169009 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🧑 [user] 💬 Latest 5 news from Italy
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_top_headlines", "args"=>{"page_size"=>5, "country"=>"it"}}
# 🤖 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"Sport Mediaset","title":"Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset","description":null,"url":"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvbWVyY2F0by9uYXBvbGkvZGktbG9yZW56by1uYXBvbGktY2Vzc2lvbmVfODI2NzY0MzMtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNjc2NDMz?oc=5","urlToImage":null,"publishedAt":"2024-05-24T06:26:20Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Interrogatorio di Toti. Il governatore respinge le accuse e deposita una memoria. «Agito nell'interesse dei cittadini, ogni euro rendicontato» - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMi1wFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9jcm9uYWNoZS8yNF9tYWdnaW9fMjMvbC1pbmNoaWVzdGEtZGktZ2Vub3ZhLXR1dHRlLWxlLWFjY3VzZS1wZXItZ2lvdmFubmktdG90aS1kYWxsYS1jb3JydXppb25lLWFsLXZvdG8tZGktc2NhbWJpby1sYS1zdWEtZGlmZXNhLWUtcXVlbGxvLWNoZS1yaXNjaGlhLTk2ODE5MjcyLTg4OTEtNDBkNy1hNzFiLTIyMjE5N2I3Ynhsay5zaHRtbNIB2wFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9jcm9uYWNoZS8yNF9tYWdnaW9fMjMvbC1pbmNoaWVzdGEtZGktZ2Vub3ZhLXR1dHRlLWxlLWFjY3VzZS1wZXItZ2lvdmFubmktdG90aS1kYWxsYS1jb3JydXppb25lLWFsLXZvdG8tZGktc2NhbWJpby1sYS1zdWEtZGlmZXNhLWUtcXVlbGxvLWNoZS1yaXNjaGlhLTk2ODE5MjcyLTg4OTEtNDBkNy1hNzFiLTIyMjE5N2I3Ynhsa19hbXAuc2h0bWw?oc=5","urlToImage":null,"publishedAt":"2024-05-24T06:23:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Il Caffé di Gramellini | L'imam a Torino e il sermone anti israele in università - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMicWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L2NhZmZlLWdyYW1lbGxpbmkvMjRfbWFnZ2lvXzI0L2FidXNvLWRpLXByZWRpY2EtODFlZjkxMGMtYmMzMi00NDFiLTg1NzEtYjE2ZjJhZDgzeGxrLnNodG1s0gEA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T06:01:41Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"SoldiOnline.it","title":"Borsa Italiana, il commento della seduta del 24 maggio 2024 - SoldiOnline.it","description":null,"url":"https://news.google.com/rss/articles/CBMiYGh0dHBzOi8vd3d3LnNvbGRpb25saW5lLml0L25vdGl6aWUvYXppb25pLWl0YWxpYS9ib3JzYS1pdGFsaWFuYS1jb21tZW50by1naW9ybmF0YS0yNC1tYWdnaW8tMjAyNNIBAA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T05:58:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Il ministro degli Esteri lituano: «La Russia non tocchi i confini sul mar Baltico. Unione Europea e Nato reagiscano» - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMiiwFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9lc3RlcmkvMjRfbWFnZ2lvXzI0L2ludGVydmlzdGEtbWluaXN0cm8tZGVnbGktZXN0ZXJpLWxpdHVhbm8tbGFuZHNiZXJnaXMtYjQwYmFjYWMtZGI4NC00NDU5LTg4OTAtNDc5NWRmYzRieGxrLnNodG1s0gGPAWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L2VzdGVyaS8yNF9tYWdnaW9fMjQvaW50ZXJ2aXN0YS1taW5pc3Ryby1kZWdsaS1lc3RlcmktbGl0dWFuby1sYW5kc2Jlcmdpcy1iNDBiYWNhYy1kYjg0LTQ0NTktODg5MC00Nzk1ZGZjNGJ4bGtfYW1wLnNodG1s?oc=5","urlToImage":null,"publishedAt":"2024-05-24T05:26:00Z","content":null}]}
# 🤖 [model] 💬 Here are the latest 5 news from Italy:
# * Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset, Sport Mediaset
# * Interrogatorio di Toti. Il governatore respinge le accuse e deposita una memoria. ‘Agito nell’interesse dei cittadini, ogni euro rendicontato’ - Corriere della Sera, Corriere della Sera
# * Il Caffè di Gramellini | L'imam a Torino e il sermone anti israele in università - Corriere della Sera, Corriere della Sera
# * Borsa Italiana, il commento della seduta del 24 maggio 2024 - SoldiOnline.it, SoldiOnline.it
# * Il ministro degli Esteri lituano: ‘La Russia non tocchi i confini sul mar Baltico. Unione Europea e Nato reagiscano’ - Corriere della Sera, Corriere della Sera
# => nil
# irb(main):026> say 'naaah give me the next 5'
# I, [2024-05-25T10:19:50.274070 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-25T10:19:52.852274 #13812]  INFO -- : [Langchain.rb] [Langchain::Tool::NewsRetriever]: Retrieving top news headlines
# I, [2024-05-25T10:19:53.294950 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🤖 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"ilmattino.it","title":"Terremoto Napoli e Campi Flegrei: nuova scossa con epicentro nel lago Lucrino - ilmattino.it","description":null,"url":"https://news.google.com/rss/articles/CBMicmh0dHBzOi8vd3d3LmlsbWF0dGluby5pdC9uYXBvbGkvYXJlYV9tZXRyb3BvbGl0YW5hL3RlcnJlbW90b19uYXBvbGlfb2dnaV91bHRpbWVfbm90aXppZV9jYW1waV9mbGVncmVpLTgxMzc4NDMuaHRtbNIBAA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T05:21:16Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Stasera tutto è possibile, le pagelle: De Martino scivola (voto 5), Stokholma «miglior scioglilingua» (voto 8) - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMi2QFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9zcGV0dGFjb2xpL2NhcmRzL3N0YXNlcmEtdHV0dG8tZS1wb3NzaWJpbGUtbGUtcGFnZWxsZS1kZS1tYXJ0aW5vLXNjaXZvbGEtdm90by01LXN0b2tob2xtYS1taWdsaW9yLXNjaW9nbGlsaW5ndWEtdm90by04L3N0ZWZhbm8tZGUtbWFydGluby1zY2l2b2xhLWUtaS1zb2NpYWwtaW1wYXp6aXNjb25vLXZvdG8tNV9wcmluY2lwYWxlLnNodG1s0gHdAWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L3NwZXR0YWNvbGkvY2FyZHMvc3Rhc2VyYS10dXR0by1lLXBvc3NpYmlsZS1sZS1wYWdlbGxlLWRlLW1hcnRpbm8tc2Npdm9sYS12b3RvLTUtc3Rva2hvbG1hLW1pZ2xpb3Itc2Npb2dsaWxpbmd1YS12b3RvLTgvc3RlZmFuby1kZS1tYXJ0aW5vLXNjaXZvbGEtZS1pLXNvY2lhbC1pbXBhenppc2Nvbm8tdm90by01X3ByaW5jaXBhbGVfYW1wLnNodG1s?oc=5","urlToImage":null,"publishedAt":"2024-05-24T05:01:54Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Agenzia ANSA","title":"Taiwan: 4 navi cinesi sono entrate nelle nostre 'acque limitate' - Ultima ora - Ansa.it - Agenzia ANSA","description":null,"url":"https://news.google.com/rss/articles/CBMimwFodHRwczovL3d3dy5hbnNhLml0L3NpdG8vbm90aXppZS90b3BuZXdzLzIwMjQvMDUvMjQvdGFpd2FuLTQtbmF2aS1jaW5lc2ktc29uby1lbnRyYXRlLW5lbGxlLW5vc3RyZS1hY3F1ZS1saW1pdGF0ZV9lNDA3OGUxNS00ODRkLTQ0NDgtYjYxMC00NzEzNjY2MWU0NzcuaHRtbNIBAA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T04:42:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"TUTTO mercato WEB","title":"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB","description":null,"url":"https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy50dXR0b21lcmNhdG93ZWIuY29tL3NlcmllLWEvY2FnbGlhcmktZmlvcmVudGluYS0yLTMtbGUtcGFnZWxsZS1yYW5pZXJpLWRhLTktcGVyLWxhLWNhcnJpZXJhLWFydGh1ci1kaS1mcmVkZGV6emEtMTk3MTYyNNIBAA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T04:15:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Ucraina - Russia in guerra, le notizie di oggi in diretta | Pechino: non abbiamo fornito armi letali a Mosca - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMiaWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L2VzdGVyaS9kaXJldHRhLWxpdmUvMjRfbWFnZ2lvXzI0L3VjcmFpbmEtcnVzc2lhLWd1ZXJyYS1ub3RpemllLW9nZ2ktZGlyZXR0YS5zaHRtbNIBbWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L2VzdGVyaS9kaXJldHRhLWxpdmUvMjRfbWFnZ2lvXzI0L3VjcmFpbmEtcnVzc2lhLWd1ZXJyYS1ub3RpemllLW9nZ2ktZGlyZXR0YV9hbXAuc2h0bWw?oc=5","urlToImage":null,"publishedAt":"2024-05-24T04:03:32Z","content":null}]}
# 🤖 [model] 💬 Here are the next 5 news from Italy:

# * Terremoto Napoli e Campi Flegrei: nuova scossa con epicentro nel lago Lucrino - ilmattino.it, ilmattino.it
# * Stasera tutto è possibile, le pagelle: De Martino scivola (voto 5), Stokholma ‘miglior scioglilingua’ (voto 8) - Corriere della Sera, Corriere della Sera
# * Taiwan: 4 navi cinesi sono entrate nelle nostre 'acque limitate' - Ultima ora - Ansa.it - Agenzia ANSA, Agenzia ANSA
# * Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB, TUTTO mercato WEB
# * Ucraina - Russia in guerra, le notizie di oggi in diretta | Pechino: non abbiamo fornito armi letali a Mosca - Corriere della Sera, Corriere della Sera
# => nil
# irb(main):027> say 'please save the two articles about sport'
# I, [2024-05-25T10:20:23.248972 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# @categories_to_be_initialized:
# Article before_save(): set_embeddings_best_effort()
# Some Embeddings are EMPTY - what I do is now needed!
# + Compute embeddings for a Article. Value: 'Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset'. Len=72
# 📊 Stats: {"truncated"=>false, "token_count"=>21}
# [...]
# ♊️ YAY! Gemini Embeddings responded with a 768-sized embedding: [0.020487479865550995, -0.008423006162047386, 0.02401338331401348], ...
# [...]
# Article::set_defaults_after (after_save). My id=6212
# I, [2024-05-25T10:20:44.119877 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🤖 [function] 🛠️  article_tool__create => {"id"=>6212, "title"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB", "summary"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB", "content"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza", "author"=>"TUTTO mercato WEB", "link"=>"https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy50dXR0b21lcmNhdG93ZWIuY29tL3NlcmllLWEvY2FnbGlhcmktZmlvcmVudGluYS0yLTMtbGUtcGFnZWxsZS1yYW5pZXJpLWRhLTktcGVyLWxhLWNhcnJpZXJhLWFydGh1ci1kaS1mcmVkZGV6emEtMTk3MTYyNNIBAA?oc=5", "published_date"=>Fri, 24 May 2024 04:15:00.000000000 UTC +00:00, "image_url"=>nil, "feed_url"=>nil, "language"=>"it", "active"=>true, "ricc_source"=>"Gemini FunctionCalling", "created_at"=>Sat, 25 May 2024 08:20:44.082198000 UTC +00:00, "updated_at"=>Sat, 25 May 2024 08:20:44.082198000 UTC +00:00, "newspaper"=>"news.google.com", "macro_region"=>"gemini-fun-call"}
# 🤖 [model] 💬 Ok, I've saved the two articles about sport. Anything else?
# => nil
# irb(main):028> say 'this is fantastic. Can you give me, for each, the carlessian url?'
# I, [2024-05-25T10:21:01.892631 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-25T10:21:04.866361 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🤖 [function] 🛠️  article_tool__carlessian_url => https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6211
# 🤖 [model] 💬 Here is the Carlessian URL for the article "Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset": https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6211
# => nil
# irb(main):029> say 'apologies i asked you to save articles 2 and 4. did you do it?'
# I, [2024-05-25T10:21:33.157505 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🧑 [user] 💬 apologies i asked you to save articles 2 and 4. did you do it?
# 🤖 [model] 💬 You are absolutely correct! I apologize for misunderstanding and saving the wrong articles. I am still under development and learning to interpret requests accurately.

# Could you please tell me the titles of articles 2 and 4 again so I can save the correct ones?
# => nil
# irb(main):030> say 'one was about Cagliari-Fiorentina 2-3, the other about le pagelle: De Martino scivola '
# I, [2024-05-25T10:22:07.490277 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-25T10:22:15.951164 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# @categories_to_be_initialized:
# Article before_save(): set_embeddings_best_effort()
# Some Embeddings are EMPTY - what I do is now needed!
# + Compute embeddings for a Article. Value: 'Stasera tutto \303\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \302\253miglior scioglilingua\302\273 (voto 8) - Corriere della Sera'. Len=153
# 📊 Stats: {"token_count"=>55, "truncated"=>false}
# 📊 cleaned_response (should be an Array) is a: Array
# ♊️ YAY! Gemini Embeddings responded with a 768-sized embedding: [0.04893818125128746, 0.001077650231309235, 0.003554682480171323], ...
# + Compute embeddings for a Article. Value: 'Stasera tutto \303\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \302\253miglior scioglilingua\302\273 (voto 8) - Corriere della Sera'. Len=153
# 📊 Stats: {"truncated"=>false, "token_count"=>55}
# 📊 cleaned_response (should be an Array) is a: Array
# ♊️ YAY! Gemini Embeddings responded with a 768-sized embedding: [0.04893818125128746, 0.001077650231309235, 0.003554682480171323], ...
# Computing ArticleEmbeddings in v2!
# 🐒🐒🐒 Monkeypatching GoogleGemini::embed() and copying from Vertex on gem (ILLEGAL) 🐒🐒🐒
# 🐒🐒🐒 Monkeypatching GoogleGemini::neha_authenticate(): Cache HIT! 🐒🐒🐒
# @categories_to_be_initialized:
# Article before_save(): set_embeddings_best_effort()
# Some Embeddings are NON EMPTY - I skip all (but TBH I should be iterating through every value...)
# - 1. title_embedding.nil? -> false
# - 2. summary_embedding.nil? -> false
# - 3. article_embedding.nil? -> false
# Article::set_defaults_after (after_save). My id=6213
# Article::set_defaults_after (after_save). My id=6213
# I, [2024-05-25T10:22:33.197282 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🤖 [function] 🛠️  article_tool__create => {"id"=>6213, "title"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8) - Corriere della Sera", "summary"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8) - Corriere della Sera", "content"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8)", "author"=>"Corriere della Sera", "link"=>"https://news.google.com/rss/articles/CBMi2QFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9zcGV0dGFjb2xpL2NhcmRzL3N0YXNlcmEtdHV0dG8tZS1wb3NzaWJpbGUtbGUtcGFnZWxsZS1kZS1tYXJ0aW5vLXNjaXZvbGEtdm90by01LXN0b2tob2xtYS1taWdsaW9yLXNjaW9nbGlsaW5ndWEtdm90by04L3N0ZWZhbm8tZGUtbWFydGluby1zY2l2b2xhLWUtaS1zb2NpYWwtaW1wYXp6aXNjb25vLXZvdG8tNV9wcmluY2lwYWxlLnNodG1s0gHdAWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L3NwZXR0YWNvbGkvY2FyZHMvc3Rhc2VyYS10dXR0by1lLXBvc3NpYmlsZS1sZS1wYWdlbGxlLWRlLW1hcnRpbm8tc2Npdm9sYS12b3RvLTUtc3Rva2hvbG1hLW1pZ2xpb3Itc2Npb2dsaWxpbmd1YS12b3RvLTgvc3RlZmFuby1kZS1tYXJ0aW5vLXNjaXZvbGEtZS1pLXNvY2lhbC1pbXBhenppc2Nvbm8tdm90by01X3ByaW5jaXBhbGVfYW1wLnNodG1s?oc=5", "published_date"=>Fri, 24 May 2024 05:01:54.000000000 UTC +00:00, "image_url"=>nil, "feed_url"=>nil, "language"=>"it", "active"=>true, "ricc_source"=>"Gemini FunctionCalling", "created_at"=>Sat, 25 May 2024 08:22:33.166442000 UTC +00:00, "updated_at"=>Sat, 25 May 2024 08:22:33.166442000 UTC +00:00, "newspaper"=>"news.google.com", "macro_region"=>"gemini-fun-call"}
# 🤖 [model] 💬 Ok, I've now saved the articles about "Cagliari-Fiorentina 2-3" and "le pagelle: De Martino scivola".

# The first one was already in my database, but I've saved the second one.

# Would you like me to generate Carlessian URLs for both of them?
# => nil
# irb(main):031> say 'yes please. in form of JSON please!'
# I, [2024-05-25T10:22:51.764041 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-25T10:22:54.385517 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-25T10:22:57.099176 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🤖 [function] 🛠️  article_tool__carlessian_url => https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6213
# 🤖 [model] 💬 ```json
# {
# "Cagliari-Fiorentina 2-3": "https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6212",
# "le pagelle: De Martino scivola": "https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6213"
# }
# ```
# => nil
# irb(main):032> say 'fantastic. Now get me ANY news regarding Bologna please'
# I, [2024-05-25T10:23:33.372395 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-25T10:23:36.427144 #13812]  INFO -- : [Langchain.rb] [Langchain::Tool::NewsRetriever]: Retrieving all news
# I, [2024-05-25T10:23:36.940137 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🤖 [function] 🛠️  news_retriever__get_everything => {"status":"ok","totalResults":3409,"articles":[{"source":{"id":null,"name":"NPR"},"author":"Gisele Grayson","title":"We asked, you answered: What are some weird things you have in common with a sibling?","description":"The answers involved career choices, sleep habits, dog greetings — and bologna eating (although to be fully transparent, we must note that was a quirk shared by an uncle and his niece).","url":"https://www.npr.org/sections/goats-and-soda/2024/05/23/1252739545/we-asked-you-answered-what-are-some-weird-things-you-have-in-common-with-a-sibling","urlToImage":"https://media.npr.org/assets/img/2024/05/22/quirky-siblings-1_wide-1895132a6c0e26191ca0d5aa85131788cb5ae413.jpg?s=1400&c=100&f=jpeg","publishedAt":"2024-05-23T09:00:00Z","content":"Photographer Tommy Trenchard (above) and his sister share the ability to pick up almost anything with their toes. Nothing is too remote a possibility for their dexterous foot digits, including a remo… [+10467 chars]"},{"source":{"id":null,"name":"Openculture.com"},"author":"Colin Marshall","title":"Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them","description":"Image by Toni Pecoraro, via Wikimedia Commons Go to practically any major city today, and you’ll notice that the buildings in certain areas are much taller than in others. That may sound trivially true, but what’s less obvious is that the height of those buil…","url":"https://www.openculture.com/2024/05/why-medieval-bologna-was-full-of-tall-towers-and-what-happened-to-them.html","urlToImage":"https://cdn8.openculture.com/2024/05/20221938/1475px-Medieval_Bologna-1024x750.jpg","publishedAt":"2024-05-21T08:00:09Z","content":"Image by Toni Pec­o­raro, via Wiki­me­dia Com­mons\r\nGo to prac­ti­cal­ly any major city today, and youll notice that the build­ings in cer­tain areas are much taller than in oth­ers. That may sound t… [+3471 chars]"},{"source":{"id":"die-zeit","name":"Die Zeit"},"author":"ZEIT ONLINE: News -","title":"Luftverkehr: Geruch an Bord: Flieger nach Frankfurt landet in Stuttgart","description":"Hier finden Sie Informationen zu dem Thema „Luftverkehr“. Lesen Sie jetzt „Geruch an Bord: Flieger nach Frankfurt landet in Stuttgart“.","url":"https://www.zeit.de/news/2024-05/07/geruch-an-bord-flieger-nach-frankfurt-landet-in-stuttgart","urlToImage":"https://img.zeit.de/news/2024-05/07/geruch-an-bord-flieger-nach-frankfurt-landet-in-stuttgart-image-group/wide__1300x731","publishedAt":"2024-05-07T03:30:34Z","content":"Wegen eines ungewöhnlichen Geruchs an Bord ist ein Flugzeug am Montagabend in Stuttgart statt in Frankfurt am Main gelandet. Das sagte eine Sprecherin des für den Flughafen zuständigen Polizeipräsidi… [+343 chars]"},{"source":{"id":null,"name":"Cheezburger.com"},"author":"Jesse Kessenheimer, Jesse Kessenheimer","title":"Happy Gen Xer rejoices after witnessing a group of bicycle kids who actually enjoy playing outside: 'This was the most mid-1980s thing ever'","description":"Nostalgia can strike at any moment, but for a Gen X dude who hasn't seen kiddos playing outside in decades, the feels hit strongest when he sees a pile of bicycles on a neighborhood lawn. Sipping Capri Suns and enjoying bologna sandwiches, one Gen X neighbor …","url":"https://cheezburger.com/25993733/happy-gen-xer-rejoices-after-witnessing-a-group-of-bicycle-kids-who-actually-enjoy-playing-outside","urlToImage":"https://i.chzbgr.com/original/25993733/h5853729E/flashback-80s-90s-wholesome-bike-bicycles-heartwarming-neighborhood-genx-boomers-millennials-gen-z","publishedAt":"2024-05-20T17:00:00Z","content":"Nostalgia can strike at any moment, but for a Gen X dude who hasn't seen kiddos playing outside in decades, the feels hit strongest when he sees a pile of bicycles on a neighborhood lawn. Sipping Cap… [+772 chars]"},{"source":{"id":null,"name":"Uol.com.br"},"author":"Igor Nishikiori","title":"Bologna x Juventus: onde assistir ao jogo do Campeonato Italiano","description":"Na briga pela terceira colocação, equipe se encaram nesta segunda-feira (20) em Bolonha. Veja quem transmite!\nThe post Bologna x Juventus: onde assistir ao jogo do Campeonato Italiano appeared first on Giz Brasil.","url":"https://gizmodo.uol.com.br/bologna-x-juventus-onde-assistir-ao-jogo-do-campeonato-italiano/","urlToImage":"https://gizmodo.uol.com.br/wp-content/blogs.dir/8/files/2024/05/juv-bolog.jpg","publishedAt":"2024-05-20T11:03:27Z","content":"A Bologna recebe a Juventus nesta segunda-feira (20), no estádio Renato Dall’Ara, na partida que fecha a penúltima rodada do Campeonato Italiano. Ambas as equipes estão empatadas com 67 pontos, porém… [+2039 chars]"}]}
# 🤖 [model] 💬 I found a few articles mentioning "Bologna". Can you be more specific? Are you interested in news about the city, a football team, or something else?
# => nil
# irb(main):033> say 'please give me their titles. Not sport, anything else, really'
# I, [2024-05-25T10:23:58.420911 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🧑 [user] 💬 please give me their titles. Not sport, anything else, really
# 🤖 [model] 💬 Here are the titles of the non-sport articles I found that mention "Bologna":

# * We asked, you answered: What are some weird things you have in common with a sibling?
# * Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them
# * Happy Gen Xer rejoices after witnessing a group of bicycle kids who actually enjoy playing outside: 'This was the most mid-1980s thing ever'

# Let me know if any of these sound interesting, or if you'd like me to refine my search further!
# => nil
# irb(main):034> say 'wow. Save the one of Medieval Bologna to DB please'
# I, [2024-05-25T10:24:25.434024 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# @categories_to_be_initialized:
# Article before_save(): set_embeddings_best_effort()
# Some Embeddings are EMPTY - what I do is now needed!
# + Compute embeddings for a Article. Value: 'Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them'. Len=71
# 📊 Stats: {"truncated"=>false, "token_count"=>19}
# 📊 cleaned_response (should be an Array) is a: Array
# ♊️ YAY! Gemini Embeddings responded with a 768-sized embedding: [0.006494322791695595, 0.002559684682637453, 0.016639597713947296], ...
# + Compute embeddings for a Article. Value: 'Image by Toni Pecoraro, via Wikimedia Commons Go to practically any major city today, and you\342\200\231ll notice that the buildings in certain areas are much taller than in others. That may sound trivially true, but what\342\200\231s less obvious is that the height of those buil\342\200\246'. Len=293
# 📊 Stats: {"truncated"=>false, "token_count"=>84}
# 📊 cleaned_response (should be an Array) is a: Array
# ♊️ YAY! Gemini Embeddings responded with a 768-sized embedding: [0.024383753538131714, 0.009443595074117184, 0.034177690744400024], ...
# Computing ArticleEmbeddings in v2!
# 🐒🐒🐒 Monkeypatching GoogleGemini::embed() and copying from Vertex on gem (ILLEGAL) 🐒🐒🐒
# 🐒🐒🐒 Monkeypatching GoogleGemini::neha_authenticate(): Cache HIT! 🐒🐒🐒
# @categories_to_be_initialized:
# Article before_save(): set_embeddings_best_effort()
# Some Embeddings are NON EMPTY - I skip all (but TBH I should be iterating through every value...)
# - 1. title_embedding.nil? -> false
# - 2. summary_embedding.nil? -> false
# - 3. article_embedding.nil? -> false
# Article::set_defaults_after (after_save). My id=6214
# Article::set_defaults_after (after_save). My id=6214
# I, [2024-05-25T10:24:38.227310 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🤖 [function] 🛠️  article_tool__create => {"id"=>6214, "title"=>"Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them", "summary"=>"Image by Toni Pecoraro, via Wikimedia Commons Go to practically any major city today, and you\\342\\200\\231ll notice that the buildings in certain areas are much taller than in others. That may sound trivially true, but what\\342\\200\\231s less obvious is that the height of those buil\\342\\200\\246", "content"=>"Image by Toni Pec\\302\\255o\\302\\255raro, via Wiki\\302\\255me\\302\\255dia Com\\302\\255mons\\\\r\\\\nGo to prac\\302\\255ti\\302\\255cal\\302\\255ly any major city today, and youll notice that the build\\302\\255ings in cer\\302\\255tain areas are much taller than in oth\\302\\255ers. That may sound t\\342\\200\\246 [+3471 chars]", "author"=>"Colin Marshall", "link"=>"https://www.openculture.com/2024/05/why-medieval-bologna-was-full-of-tall-towers-and-what-happened-to-them.html", "published_date"=>Tue, 21 May 2024 08:00:09.000000000 UTC +00:00, "image_url"=>nil, "feed_url"=>nil, "language"=>"en", "active"=>true, "ricc_source"=>"Gemini FunctionCalling", "created_at"=>Sat, 25 May 2024 08:24:38.204132000 UTC +00:00, "updated_at"=>Sat, 25 May 2024 08:24:38.204132000 UTC +00:00, "newspaper"=>"www.openculture.com", "macro_region"=>"gemini-fun-call"}
# 🤖 [model] 💬 Done! I've saved the article "Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them" to the database.

# Anything else?
# => nil
# irb(main):035> say 'please give me now the carlessian url'
# I, [2024-05-25T10:24:51.772607 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# I, [2024-05-25T10:24:55.072702 #13812]  INFO -- : [Langchain.rb] [Langchain::Assistant]: Sending a call to Langchain::LLM::GoogleGemini
# 🤖 [function] 🛠️  article_tool__carlessian_url => https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6214
# 🤖 [model] 💬 Here's the Carlessian URL for the article: https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6214
# => nil
# irb(main):036>
# irb(main):037>
# irb(main):038> history
# => nil
# irb(main):039> @assistant.history
# 🧑 [user] 💬 Latest 5 news from Italy
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_top_headlines", "args"=>{"page_size"=>5, "country"=>"it"}}
# 🤖 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"Sport Mediaset","title":"Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset","description":null,"url":"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvbWVyY2F0by9uYXBvbGkvZGktbG9yZW56by1uYXBvbGktY2Vzc2lvbmVfODI2NzY0MzMtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNjc2NDMz?oc=5","urlToImage":null,"publishedAt":"2024-05-24T06:26:20Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Interrogatorio di Toti. Il governatore respinge le accuse e deposita una memoria. «Agito nell'interesse dei cittadini, ogni euro rendicontato» - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMi1wFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9jcm9uYWNoZS8yNF9tYWdnaW9fMjMvbC1pbmNoaWVzdGEtZGktZ2Vub3ZhLXR1dHRlLWxlLWFjY3VzZS1wZXItZ2lvdmFubmktdG90aS1kYWxsYS1jb3JydXppb25lLWFsLXZvdG8tZGktc2NhbWJpby1sYS1zdWEtZGlmZXNhLWUtcXVlbGxvLWNoZS1yaXNjaGlhLTk2ODE5MjcyLTg4OTEtNDBkNy1hNzFiLTIyMjE5N2I3Ynhsay5zaHRtbNIB2wFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9jcm9uYWNoZS8yNF9tYWdnaW9fMjMvbC1pbmNoaWVzdGEtZGktZ2Vub3ZhLXR1dHRlLWxlLWFjY3VzZS1wZXItZ2lvdmFubmktdG90aS1kYWxsYS1jb3JydXppb25lLWFsLXZvdG8tZGktc2NhbWJpby1sYS1zdWEtZGlmZXNhLWUtcXVlbGxvLWNoZS1yaXNjaGlhLTk2ODE5MjcyLTg4OTEtNDBkNy1hNzFiLTIyMjE5N2I3Ynhsa19hbXAuc2h0bWw?oc=5","urlToImage":null,"publishedAt":"2024-05-24T06:23:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Il Caffé di Gramellini | L'imam a Torino e il sermone anti israele in università - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMicWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L2NhZmZlLWdyYW1lbGxpbmkvMjRfbWFnZ2lvXzI0L2FidXNvLWRpLXByZWRpY2EtODFlZjkxMGMtYmMzMi00NDFiLTg1NzEtYjE2ZjJhZDgzeGxrLnNodG1s0gEA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T06:01:41Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"SoldiOnline.it","title":"Borsa Italiana, il commento della seduta del 24 maggio 2024 - SoldiOnline.it","description":null,"url":"https://news.google.com/rss/articles/CBMiYGh0dHBzOi8vd3d3LnNvbGRpb25saW5lLml0L25vdGl6aWUvYXppb25pLWl0YWxpYS9ib3JzYS1pdGFsaWFuYS1jb21tZW50by1naW9ybmF0YS0yNC1tYWdnaW8tMjAyNNIBAA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T05:58:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Il ministro degli Esteri lituano: «La Russia non tocchi i confini sul mar Baltico. Unione Europea e Nato reagiscano» - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMiiwFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9lc3RlcmkvMjRfbWFnZ2lvXzI0L2ludGVydmlzdGEtbWluaXN0cm8tZGVnbGktZXN0ZXJpLWxpdHVhbm8tbGFuZHNiZXJnaXMtYjQwYmFjYWMtZGI4NC00NDU5LTg4OTAtNDc5NWRmYzRieGxrLnNodG1s0gGPAWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L2VzdGVyaS8yNF9tYWdnaW9fMjQvaW50ZXJ2aXN0YS1taW5pc3Ryby1kZWdsaS1lc3RlcmktbGl0dWFuby1sYW5kc2Jlcmdpcy1iNDBiYWNhYy1kYjg0LTQ0NTktODg5MC00Nzk1ZGZjNGJ4bGtfYW1wLnNodG1s?oc=5","urlToImage":null,"publishedAt":"2024-05-24T05:26:00Z","content":null}]}
# 🤖 [model] 💬 Here are the latest 5 news from Italy:

# * Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset, Sport Mediaset
# * Interrogatorio di Toti. Il governatore respinge le accuse e deposita una memoria. ‘Agito nell’interesse dei cittadini, ogni euro rendicontato’ - Corriere della Sera, Corriere della Sera
# * Il Caffè di Gramellini | L'imam a Torino e il sermone anti israele in università - Corriere della Sera, Corriere della Sera
# * Borsa Italiana, il commento della seduta del 24 maggio 2024 - SoldiOnline.it, SoldiOnline.it
# * Il ministro degli Esteri lituano: ‘La Russia non tocchi i confini sul mar Baltico. Unione Europea e Nato reagiscano’ - Corriere della Sera, Corriere della Sera
# 🧑 [user] 💬 naaah give me the next 5
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_top_headlines", "args"=>{"page_size"=>5, "country"=>"it", "page"=>2}}
# 🤖 [function] 🛠️  news_retriever__get_top_headlines => {"status":"ok","totalResults":34,"articles":[{"source":{"id":"google-news","name":"Google News"},"author":"ilmattino.it","title":"Terremoto Napoli e Campi Flegrei: nuova scossa con epicentro nel lago Lucrino - ilmattino.it","description":null,"url":"https://news.google.com/rss/articles/CBMicmh0dHBzOi8vd3d3LmlsbWF0dGluby5pdC9uYXBvbGkvYXJlYV9tZXRyb3BvbGl0YW5hL3RlcnJlbW90b19uYXBvbGlfb2dnaV91bHRpbWVfbm90aXppZV9jYW1waV9mbGVncmVpLTgxMzc4NDMuaHRtbNIBAA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T05:21:16Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Stasera tutto è possibile, le pagelle: De Martino scivola (voto 5), Stokholma «miglior scioglilingua» (voto 8) - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMi2QFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9zcGV0dGFjb2xpL2NhcmRzL3N0YXNlcmEtdHV0dG8tZS1wb3NzaWJpbGUtbGUtcGFnZWxsZS1kZS1tYXJ0aW5vLXNjaXZvbGEtdm90by01LXN0b2tob2xtYS1taWdsaW9yLXNjaW9nbGlsaW5ndWEtdm90by04L3N0ZWZhbm8tZGUtbWFydGluby1zY2l2b2xhLWUtaS1zb2NpYWwtaW1wYXp6aXNjb25vLXZvdG8tNV9wcmluY2lwYWxlLnNodG1s0gHdAWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L3NwZXR0YWNvbGkvY2FyZHMvc3Rhc2VyYS10dXR0by1lLXBvc3NpYmlsZS1sZS1wYWdlbGxlLWRlLW1hcnRpbm8tc2Npdm9sYS12b3RvLTUtc3Rva2hvbG1hLW1pZ2xpb3Itc2Npb2dsaWxpbmd1YS12b3RvLTgvc3RlZmFuby1kZS1tYXJ0aW5vLXNjaXZvbGEtZS1pLXNvY2lhbC1pbXBhenppc2Nvbm8tdm90by01X3ByaW5jaXBhbGVfYW1wLnNodG1s?oc=5","urlToImage":null,"publishedAt":"2024-05-24T05:01:54Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Agenzia ANSA","title":"Taiwan: 4 navi cinesi sono entrate nelle nostre 'acque limitate' - Ultima ora - Ansa.it - Agenzia ANSA","description":null,"url":"https://news.google.com/rss/articles/CBMimwFodHRwczovL3d3dy5hbnNhLml0L3NpdG8vbm90aXppZS90b3BuZXdzLzIwMjQvMDUvMjQvdGFpd2FuLTQtbmF2aS1jaW5lc2ktc29uby1lbnRyYXRlLW5lbGxlLW5vc3RyZS1hY3F1ZS1saW1pdGF0ZV9lNDA3OGUxNS00ODRkLTQ0NDgtYjYxMC00NzEzNjY2MWU0NzcuaHRtbNIBAA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T04:42:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"TUTTO mercato WEB","title":"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB","description":null,"url":"https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy50dXR0b21lcmNhdG93ZWIuY29tL3NlcmllLWEvY2FnbGlhcmktZmlvcmVudGluYS0yLTMtbGUtcGFnZWxsZS1yYW5pZXJpLWRhLTktcGVyLWxhLWNhcnJpZXJhLWFydGh1ci1kaS1mcmVkZGV6emEtMTk3MTYyNNIBAA?oc=5","urlToImage":null,"publishedAt":"2024-05-24T04:15:00Z","content":null},{"source":{"id":"google-news","name":"Google News"},"author":"Corriere della Sera","title":"Ucraina - Russia in guerra, le notizie di oggi in diretta | Pechino: non abbiamo fornito armi letali a Mosca - Corriere della Sera","description":null,"url":"https://news.google.com/rss/articles/CBMiaWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L2VzdGVyaS9kaXJldHRhLWxpdmUvMjRfbWFnZ2lvXzI0L3VjcmFpbmEtcnVzc2lhLWd1ZXJyYS1ub3RpemllLW9nZ2ktZGlyZXR0YS5zaHRtbNIBbWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L2VzdGVyaS9kaXJldHRhLWxpdmUvMjRfbWFnZ2lvXzI0L3VjcmFpbmEtcnVzc2lhLWd1ZXJyYS1ub3RpemllLW9nZ2ktZGlyZXR0YV9hbXAuc2h0bWw?oc=5","urlToImage":null,"publishedAt":"2024-05-24T04:03:32Z","content":null}]}
# 🤖 [model] 💬 Here are the next 5 news from Italy:

# * Terremoto Napoli e Campi Flegrei: nuova scossa con epicentro nel lago Lucrino - ilmattino.it, ilmattino.it
# * Stasera tutto è possibile, le pagelle: De Martino scivola (voto 5), Stokholma ‘miglior scioglilingua’ (voto 8) - Corriere della Sera, Corriere della Sera
# * Taiwan: 4 navi cinesi sono entrate nelle nostre 'acque limitate' - Ultima ora - Ansa.it - Agenzia ANSA, Agenzia ANSA
# * Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB, TUTTO mercato WEB
# * Ucraina - Russia in guerra, le notizie di oggi in diretta | Pechino: non abbiamo fornito armi letali a Mosca - Corriere della Sera, Corriere della Sera
# 🧑 [user] 💬 please save the two articles about sport
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__create", "args"=>{"language"=>"it", "author"=>"Sport Mediaset", "content"=>"Napoli, Di Lorenzo chiede di andare via", "link"=>"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvbWVyY2F0by9uYXBvbGkvZGktbG9yZW56by1uYXBvbGktY2Vzc2lvbmVfODI2NzY0MzMtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNjc2NDMz?oc=5", "title"=>"Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset", "summary"=>"Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset", "published_date"=>"2024-05-24T06:26:20Z", "country"=>"Italy", "country_emoji"=>"🇮🇹"}}
# 🤖 [function] 🛠️  article_tool__create => {"id"=>6211, "title"=>"Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset", "summary"=>"Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset", "content"=>"Napoli, Di Lorenzo chiede di andare via", "author"=>"Sport Mediaset", "link"=>"https://news.google.com/rss/articles/CBMiZmh0dHBzOi8vd3d3LnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvbWVyY2F0by9uYXBvbGkvZGktbG9yZW56by1uYXBvbGktY2Vzc2lvbmVfODI2NzY0MzMtMjAyNDAyay5zaHRtbNIBRGh0dHBzOi8vYW1wLnNwb3J0bWVkaWFzZXQubWVkaWFzZXQuaXQvc3BvcnRtZWRpYXNldC9hcnRpY2xlLzgyNjc2NDMz?oc=5", "published_date"=>Fri, 24 May 2024 06:26:20.000000000 UTC +00:00, "image_url"=>nil, "feed_url"=>nil, "language"=>"it", "active"=>true, "ricc_source"=>"Gemini FunctionCalling", "created_at"=>Sat, 25 May 2024 08:20:33.266071000 UTC +00:00, "updated_at"=>Sat, 25 May 2024 08:20:33.266071000 UTC +00:00, "newspaper"=>"news.google.com", "macro_region"=>"gemini-fun-call"}
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__create", "args"=>{"link"=>"https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy50dXR0b21lcmNhdG93ZWIuY29tL3NlcmllLWEvY2FnbGlhcmktZmlvcmVudGluYS0yLTMtbGUtcGFnZWxsZS1yYW5pZXJpLWRhLTktcGVyLWxhLWNhcnJpZXJhLWFydGh1ci1kaS1mcmVkZGV6emEtMTk3MTYyNNIBAA?oc=5", "content"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza", "country_emoji"=>"\\360\\237\\207\\256\\360\\237\\207\\271", "author"=>"TUTTO mercato WEB", "published_date"=>"2024-05-24T04:15:00Z", "title"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB", "language"=>"it", "country"=>"Italy", "summary"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB"}}
# 🤖 [function] 🛠️  article_tool__create => {"id"=>6212, "title"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB", "summary"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB", "content"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza", "author"=>"TUTTO mercato WEB", "link"=>"https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy50dXR0b21lcmNhdG93ZWIuY29tL3NlcmllLWEvY2FnbGlhcmktZmlvcmVudGluYS0yLTMtbGUtcGFnZWxsZS1yYW5pZXJpLWRhLTktcGVyLWxhLWNhcnJpZXJhLWFydGh1ci1kaS1mcmVkZGV6emEtMTk3MTYyNNIBAA?oc=5", "published_date"=>Fri, 24 May 2024 04:15:00.000000000 UTC +00:00, "image_url"=>nil, "feed_url"=>nil, "language"=>"it", "active"=>true, "ricc_source"=>"Gemini FunctionCalling", "created_at"=>Sat, 25 May 2024 08:20:44.082198000 UTC +00:00, "updated_at"=>Sat, 25 May 2024 08:20:44.082198000 UTC +00:00, "newspaper"=>"news.google.com", "macro_region"=>"gemini-fun-call"}
# 🤖 [model] 💬 Ok, I've saved the two articles about sport. Anything else?
# 🧑 [user] 💬 this is fantastic. Can you give me, for each, the carlessian url?
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__carlessian_url", "args"=>{"id"=>6211}}
# 🤖 [function] 🛠️  article_tool__carlessian_url => https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6211
# 🤖 [model] 💬 Here is the Carlessian URL for the article "Napoli, Di Lorenzo chiede di andare via - Sportmediaset - Sport Mediaset": https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6211
# 🧑 [user] 💬 apologies i asked you to save articles 2 and 4. did you do it?
# 🤖 [model] 💬 You are absolutely correct! I apologize for misunderstanding and saving the wrong articles. I am still under development and learning to interpret requests accurately.

# Could you please tell me the titles of articles 2 and 4 again so I can save the correct ones?
# 🧑 [user] 💬 one was about Cagliari-Fiorentina 2-3, the other about le pagelle: De Martino scivola
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__create", "args"=>{"link"=>"https://news.google.com/rss/articles/CBMigwFodHRwczovL3d3dy50dXR0b21lcmNhdG93ZWIuY29tL3NlcmllLWEvY2FnbGlhcmktZmlvcmVudGluYS0yLTMtbGUtcGFnZWxsZS1yYW5pZXJpLWRhLTktcGVyLWxhLWNhcnJpZXJhLWFydGh1ci1kaS1mcmVkZGV6emEtMTk3MTYyNNIBAA?oc=5", "summary"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB", "language"=>"it", "published_date"=>"2024-05-24T04:15:00Z", "title"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza - TUTTO mercato WEB", "content"=>"Cagliari-Fiorentina 2-3, le pagelle: Ranieri da 9 per la carriera, Arthur di freddezza", "country"=>"Italy", "author"=>"TUTTO mercato WEB", "country_emoji"=>"\\\\360\\\\237\\\\207\\\\256\\\\360\\\\237\\\\207\\\\271"}}
# 🤖 [function] 🛠️  article_tool__create => ["Title has already been taken", "Guid has already been taken"]
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__create", "args"=>{"author"=>"Corriere della Sera", "country"=>"Italy", "content"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8)", "title"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8) - Corriere della Sera", "link"=>"https://news.google.com/rss/articles/CBMi2QFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9zcGV0dGFjb2xpL2NhcmRzL3N0YXNlcmEtdHV0dG8tZS1wb3NzaWJpbGUtbGUtcGFnZWxsZS1kZS1tYXJ0aW5vLXNjaXZvbGEtdm90by01LXN0b2tob2xtYS1taWdsaW9yLXNjaW9nbGlsaW5ndWEtdm90by04L3N0ZWZhbm8tZGUtbWFydGluby1zY2l2b2xhLWUtaS1zb2NpYWwtaW1wYXp6aXNjb25vLXZvdG8tNV9wcmluY2lwYWxlLnNodG1s0gHdAWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L3NwZXR0YWNvbGkvY2FyZHMvc3Rhc2VyYS10dXR0by1lLXBvc3NpYmlsZS1sZS1wYWdlbGxlLWRlLW1hcnRpbm8tc2Npdm9sYS12b3RvLTUtc3Rva2hvbG1hLW1pZ2xpb3Itc2Npb2dsaWxpbmd1YS12b3RvLTgvc3RlZmFuby1kZS1tYXJ0aW5vLXNjaXZvbGEtZS1pLXNvY2lhbC1pbXBhenppc2Nvbm8tdm90by01X3ByaW5jaXBhbGVfYW1wLnNodG1s?oc=5", "country_emoji"=>"\\\\\\\\360\\\\\\\\237\\\\\\\\207\\\\\\\\256\\\\\\\\360\\\\\\\\237\\\\\\\\207\\\\\\\\271", "summary"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8) - Corriere della Sera", "published_date"=>"2024-05-24T05:01:54Z", "language"=>"it"}}
# 🤖 [function] 🛠️  article_tool__create => {"id"=>6213, "title"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8) - Corriere della Sera", "summary"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8) - Corriere della Sera", "content"=>"Stasera tutto \\303\\250 possibile, le pagelle: De Martino scivola (voto 5), Stokholma \\302\\253miglior scioglilingua\\302\\273 (voto 8)", "author"=>"Corriere della Sera", "link"=>"https://news.google.com/rss/articles/CBMi2QFodHRwczovL3d3dy5jb3JyaWVyZS5pdC9zcGV0dGFjb2xpL2NhcmRzL3N0YXNlcmEtdHV0dG8tZS1wb3NzaWJpbGUtbGUtcGFnZWxsZS1kZS1tYXJ0aW5vLXNjaXZvbGEtdm90by01LXN0b2tob2xtYS1taWdsaW9yLXNjaW9nbGlsaW5ndWEtdm90by04L3N0ZWZhbm8tZGUtbWFydGluby1zY2l2b2xhLWUtaS1zb2NpYWwtaW1wYXp6aXNjb25vLXZvdG8tNV9wcmluY2lwYWxlLnNodG1s0gHdAWh0dHBzOi8vd3d3LmNvcnJpZXJlLml0L3NwZXR0YWNvbGkvY2FyZHMvc3Rhc2VyYS10dXR0by1lLXBvc3NpYmlsZS1sZS1wYWdlbGxlLWRlLW1hcnRpbm8tc2Npdm9sYS12b3RvLTUtc3Rva2hvbG1hLW1pZ2xpb3Itc2Npb2dsaWxpbmd1YS12b3RvLTgvc3RlZmFuby1kZS1tYXJ0aW5vLXNjaXZvbGEtZS1pLXNvY2lhbC1pbXBhenppc2Nvbm8tdm90by01X3ByaW5jaXBhbGVfYW1wLnNodG1s?oc=5", "published_date"=>Fri, 24 May 2024 05:01:54.000000000 UTC +00:00, "image_url"=>nil, "feed_url"=>nil, "language"=>"it", "active"=>true, "ricc_source"=>"Gemini FunctionCalling", "created_at"=>Sat, 25 May 2024 08:22:33.166442000 UTC +00:00, "updated_at"=>Sat, 25 May 2024 08:22:33.166442000 UTC +00:00, "newspaper"=>"news.google.com", "macro_region"=>"gemini-fun-call"}
# 🤖 [model] 💬 Ok, I've now saved the articles about "Cagliari-Fiorentina 2-3" and "le pagelle: De Martino scivola".

# The first one was already in my database, but I've saved the second one.

# Would you like me to generate Carlessian URLs for both of them?
# 🧑 [user] 💬 yes please. in form of JSON please!
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__carlessian_url", "args"=>{"id"=>6212}}
# 🤖 [function] 🛠️  article_tool__carlessian_url => https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6212
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__carlessian_url", "args"=>{"id"=>6213}}
# 🤖 [function] 🛠️  article_tool__carlessian_url => https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6213
# 🤖 [model] 💬 ```json
# {
# "Cagliari-Fiorentina 2-3": "https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6212",
# "le pagelle: De Martino scivola": "https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6213"
# }
# ```
# 🧑 [user] 💬 fantastic. Now get me ANY news regarding Bologna please
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"news_retriever__get_everything", "args"=>{"q"=>"Bologna"}}
# 🤖 [function] 🛠️  news_retriever__get_everything => {"status":"ok","totalResults":3409,"articles":[{"source":{"id":null,"name":"NPR"},"author":"Gisele Grayson","title":"We asked, you answered: What are some weird things you have in common with a sibling?","description":"The answers involved career choices, sleep habits, dog greetings — and bologna eating (although to be fully transparent, we must note that was a quirk shared by an uncle and his niece).","url":"https://www.npr.org/sections/goats-and-soda/2024/05/23/1252739545/we-asked-you-answered-what-are-some-weird-things-you-have-in-common-with-a-sibling","urlToImage":"https://media.npr.org/assets/img/2024/05/22/quirky-siblings-1_wide-1895132a6c0e26191ca0d5aa85131788cb5ae413.jpg?s=1400&c=100&f=jpeg","publishedAt":"2024-05-23T09:00:00Z","content":"Photographer Tommy Trenchard (above) and his sister share the ability to pick up almost anything with their toes. Nothing is too remote a possibility for their dexterous foot digits, including a remo… [+10467 chars]"},{"source":{"id":null,"name":"Openculture.com"},"author":"Colin Marshall","title":"Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them","description":"Image by Toni Pecoraro, via Wikimedia Commons Go to practically any major city today, and you’ll notice that the buildings in certain areas are much taller than in others. That may sound trivially true, but what’s less obvious is that the height of those buil…","url":"https://www.openculture.com/2024/05/why-medieval-bologna-was-full-of-tall-towers-and-what-happened-to-them.html","urlToImage":"https://cdn8.openculture.com/2024/05/20221938/1475px-Medieval_Bologna-1024x750.jpg","publishedAt":"2024-05-21T08:00:09Z","content":"Image by Toni Pec­o­raro, via Wiki­me­dia Com­mons\r\nGo to prac­ti­cal­ly any major city today, and youll notice that the build­ings in cer­tain areas are much taller than in oth­ers. That may sound t… [+3471 chars]"},{"source":{"id":"die-zeit","name":"Die Zeit"},"author":"ZEIT ONLINE: News -","title":"Luftverkehr: Geruch an Bord: Flieger nach Frankfurt landet in Stuttgart","description":"Hier finden Sie Informationen zu dem Thema „Luftverkehr“. Lesen Sie jetzt „Geruch an Bord: Flieger nach Frankfurt landet in Stuttgart“.","url":"https://www.zeit.de/news/2024-05/07/geruch-an-bord-flieger-nach-frankfurt-landet-in-stuttgart","urlToImage":"https://img.zeit.de/news/2024-05/07/geruch-an-bord-flieger-nach-frankfurt-landet-in-stuttgart-image-group/wide__1300x731","publishedAt":"2024-05-07T03:30:34Z","content":"Wegen eines ungewöhnlichen Geruchs an Bord ist ein Flugzeug am Montagabend in Stuttgart statt in Frankfurt am Main gelandet. Das sagte eine Sprecherin des für den Flughafen zuständigen Polizeipräsidi… [+343 chars]"},{"source":{"id":null,"name":"Cheezburger.com"},"author":"Jesse Kessenheimer, Jesse Kessenheimer","title":"Happy Gen Xer rejoices after witnessing a group of bicycle kids who actually enjoy playing outside: 'This was the most mid-1980s thing ever'","description":"Nostalgia can strike at any moment, but for a Gen X dude who hasn't seen kiddos playing outside in decades, the feels hit strongest when he sees a pile of bicycles on a neighborhood lawn. Sipping Capri Suns and enjoying bologna sandwiches, one Gen X neighbor …","url":"https://cheezburger.com/25993733/happy-gen-xer-rejoices-after-witnessing-a-group-of-bicycle-kids-who-actually-enjoy-playing-outside","urlToImage":"https://i.chzbgr.com/original/25993733/h5853729E/flashback-80s-90s-wholesome-bike-bicycles-heartwarming-neighborhood-genx-boomers-millennials-gen-z","publishedAt":"2024-05-20T17:00:00Z","content":"Nostalgia can strike at any moment, but for a Gen X dude who hasn't seen kiddos playing outside in decades, the feels hit strongest when he sees a pile of bicycles on a neighborhood lawn. Sipping Cap… [+772 chars]"},{"source":{"id":null,"name":"Uol.com.br"},"author":"Igor Nishikiori","title":"Bologna x Juventus: onde assistir ao jogo do Campeonato Italiano","description":"Na briga pela terceira colocação, equipe se encaram nesta segunda-feira (20) em Bolonha. Veja quem transmite!\nThe post Bologna x Juventus: onde assistir ao jogo do Campeonato Italiano appeared first on Giz Brasil.","url":"https://gizmodo.uol.com.br/bologna-x-juventus-onde-assistir-ao-jogo-do-campeonato-italiano/","urlToImage":"https://gizmodo.uol.com.br/wp-content/blogs.dir/8/files/2024/05/juv-bolog.jpg","publishedAt":"2024-05-20T11:03:27Z","content":"A Bologna recebe a Juventus nesta segunda-feira (20), no estádio Renato Dall’Ara, na partida que fecha a penúltima rodada do Campeonato Italiano. Ambas as equipes estão empatadas com 67 pontos, porém… [+2039 chars]"}]}
# 🤖 [model] 💬 I found a few articles mentioning "Bologna". Can you be more specific? Are you interested in news about the city, a football team, or something else?
# 🧑 [user] 💬 please give me their titles. Not sport, anything else, really
# 🤖 [model] 💬 Here are the titles of the non-sport articles I found that mention "Bologna":

# * We asked, you answered: What are some weird things you have in common with a sibling?
# * Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them
# * Happy Gen Xer rejoices after witnessing a group of bicycle kids who actually enjoy playing outside: 'This was the most mid-1980s thing ever'

# Let me know if any of these sound interesting, or if you'd like me to refine my search further!
# 🧑 [user] 💬 wow. Save the one of Medieval Bologna to DB please
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__create", "args"=>{"title"=>"Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them", "author"=>"Colin Marshall", "language"=>"en", "published_date"=>"2024-05-21T08:00:09Z", "content"=>"Image by Toni Pec\\302\\255o\\302\\255raro, via Wiki\\302\\255me\\302\\255dia Com\\302\\255mons\\\\r\\\\nGo to prac\\302\\255ti\\302\\255cal\\302\\255ly any major city today, and youll notice that the build\\302\\255ings in cer\\302\\255tain areas are much taller than in oth\\302\\255ers. That may sound t\\342\\200\\246 [+3471 chars]", "summary"=>"Image by Toni Pecoraro, via Wikimedia Commons Go to practically any major city today, and you\\342\\200\\231ll notice that the buildings in certain areas are much taller than in others. That may sound trivially true, but what\\342\\200\\231s less obvious is that the height of those buil\\342\\200\\246", "country"=>"Vatican City", "link"=>"https://www.openculture.com/2024/05/why-medieval-bologna-was-full-of-tall-towers-and-what-happened-to-them.html", "country_emoji"=>"\\\\\\360\\\\237\\\\207\\\\256\\\\360\\\\237\\\\207\\\\271"}}
# 🤖 [function] 🛠️  article_tool__create => {"id"=>6214, "title"=>"Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them", "summary"=>"Image by Toni Pecoraro, via Wikimedia Commons Go to practically any major city today, and you\\342\\200\\231ll notice that the buildings in certain areas are much taller than in others. That may sound trivially true, but what\\342\\200\\231s less obvious is that the height of those buil\\342\\200\\246", "content"=>"Image by Toni Pec\\302\\255o\\302\\255raro, via Wiki\\302\\255me\\302\\255dia Com\\302\\255mons\\\\r\\\\nGo to prac\\302\\255ti\\302\\255cal\\302\\255ly any major city today, and youll notice that the build\\302\\255ings in cer\\302\\255tain areas are much taller than in oth\\302\\255ers. That may sound t\\342\\200\\246 [+3471 chars]", "author"=>"Colin Marshall", "link"=>"https://www.openculture.com/2024/05/why-medieval-bologna-was-full-of-tall-towers-and-what-happened-to-them.html", "published_date"=>Tue, 21 May 2024 08:00:09.000000000 UTC +00:00, "image_url"=>nil, "feed_url"=>nil, "language"=>"en", "active"=>true, "ricc_source"=>"Gemini FunctionCalling", "created_at"=>Sat, 25 May 2024 08:24:38.204132000 UTC +00:00, "updated_at"=>Sat, 25 May 2024 08:24:38.204132000 UTC +00:00, "newspaper"=>"www.openculture.com", "macro_region"=>"gemini-fun-call"}
# 🤖 [model] 💬 Done! I've saved the article "Why Medieval Bologna Was Full of Tall Towers, and What Happened to Them" to the database.

# Anything else?
# 🧑 [user] 💬 please give me now the carlessian url
# 🤖 [model] 🛠️ [1/1] 🛠️  {"name"=>"article_tool__carlessian_url", "args"=>{"id"=>6214}}
# 🤖 [function] 🛠️  article_tool__carlessian_url => https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6214
# 🤖 [model] 💬 Here's the Carlessian URL for the article: https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/6214
# => nil
