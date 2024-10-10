# # New world: https://github.com/patterns-ai-core/langchainrb/blob/main/lib/langchain/tool/calculator.rb
# # Note: Moved to MonkeyPatch

# # module Langchain::Tool
# #   class Calculator
# #     extend Langchain::ToolDefinition
# #     include Langchain::DependencyHelper
# module Langchain::Tool
#   class Article
#     VERSION = '1.11'
#     CHANGELOG = <<-TEXT
#       v1.11 Started on 9oct24 to address the new Langchain tool

#       v1.10 Added Carlessian url: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/articles/#id
#       v1.9  Got a delete error - tried to perfect the JSON decription

#       app/tools/article_tool.rb:94:in `destroy': wrong number of arguments (given 1, expected 0; required keyword: id) (ArgumentError)

#       v1.8 Got a create error by unknown city -> defaults now to Vatican.

#       app/tools/article_tool.rb:37:in `create': missing keywords: :country, :country_emoji (ArgumentError)

#       v1.7 now create() sends a more verbose output in return (whole object instead of just id)
#       v1.6 fixed missing `delete` function. Bug:

#         (irb):10:in `say': undefined method `delete' for #<ArticleTool:0x00007f97d69cc1b8> (NoMethodError)

#       v1.5 Added UTF8 in the code (I trust myself more than an AI :P). Altenratvie would be to sanitize UTF8 in the EXIT of the
#           NewsRetriever but that's built into Langchain::Tool::NewsRetriever gem so it would be yet another thing to override.
#       v1.4 Added UTF8 in the specs since the output is very ugly now: http://localhost:3000/articles/10334
#       v1.3
#       v1.2 Add EMOJI so AI finds emoji for me and I can just put somewhere easy to parse :)
#       v1.1 GUID is now the Link. Also fixing macro-region
#       v1.0 First version from Andrei

#     TEXT

#     extend Langchain::ToolDefinition
#     include Langchain::DependencyHelper

#     define_function :create, description: "Article DB Tool: Create a new article via ActiveRecord"

#     # Initialize the ArticleTool
#     def initialize; end

#     def create(
#       title:,
#       summary:,
#       content:,
#       author:,
#       link:,
#       published_date:,
#       language:,
#       country:,
#       country_emoji:
#     )
#       # This will be converted to string in the DB - no biggie. Easy to reverse.
#       hashy_blurb = {
#         country:,
#         country_emoji:,
#         article_tool_version: VERSION
#       }
#       article = Article.create(
#         title: title.force_encoding('UTF-8'),
#         summary: summary.force_encoding('UTF-8'),
#         content: content.force_encoding('UTF-8'),
#         author:,
#         link:,
#         published_date:,
#         language:,
#         # guid: SecureRandom.uuid, # maybe link itself
#         guid: link,
#         newspaper: link.split('/')[2], # https://www.begeek.fr/google -> "www.begeek.fr"
#         macro_region: 'gemini-fun-call',
#         hidden_blurb: hashy_blurb.to_s,
#         ricc_internal_notes: "Created through Andrei's amazing ArticleTool #{NAME} v#{VERSION}.
#           parsable_blurb = {
#             country: '#{country}',
#             country_emoji: '#{country_emoji}',
#           }
#         ",
#         ricc_source: 'Gemini FunctionCalling'
#       )

#       if article.persisted?
#         # { id: article.id }
#         # returning the whole object as suggested by Andrei in his video
#         # https://drive.google.com/file/d/1U_hStFa3PmphfHM9xuhNM1W4uQdSwgv5/view?resourcekey=0-EE3YdWxYmp0_YgUGgBk9KQ
#         article.interesting_attributes # redacting the embeddings ones
#       else
#         article.errors.full_messages
#       end
#     end

#   end
# end
