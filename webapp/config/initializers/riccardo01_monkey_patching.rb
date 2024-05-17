puts("🐒🐒🐒 webapp/config/initializers/riccardo_monkey_patching.rb 🐒🐒🐒")

# Monkeypatching the CHAT because I need to use Gemini URI and Vertex Auth. In reality I need some kind of hybrid
# thingy.
#
# == GoogleVertexAI ==
# 3 changes need to happen to make GoogleVertexAI work with Gemini functions:
#   1. Add the two scopes to Auth. This fixes authenticaiton both for GCP and for consumer api key.
#      This is in LATEST but not in the gem, so I have to re-code it in this `initialize()`
#   2. Add Gemini URL `generativelanguage.googleapis.com`. This forces me to monkey-patch `chat()`
#   3. Add Gemini 1.5/. This requires no refactoring - I just changed the constructor in
#      `webapp/vertex_ai_sample_andrei.rb`. I still cant understand why this wont work with Gemini 1.0
#      when docs says it works fine.
#  Let's see if the Zeitgeist gets angry at this MonkeyPatching.
#
#  Plus, if youw ant GeminiLLM to calculate embeddings, it cannot. You either need VertexLLM OR you can just monkeypatch
#  the same function. In this case, though, you need to also add  embeddings_model_name: "textembedding-gecko" to
#   DEFAULTS = { .. }
#
# == GoogleGemini ==
# Had to change the embed..
#

# class Google::Auth::GCECredentials
#   def project_id
#     'palladius-genai' # TODO move to ENV[] ma lo posso testare solo a manhouse..
#   end
# end
