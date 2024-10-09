# New world: https://github.com/patterns-ai-core/langchainrb/blob/main/lib/langchain/tool/calculator.rb

# module Langchain::Tool
#   class Calculator
#     extend Langchain::ToolDefinition
#     include Langchain::DependencyHelper
module Langchain::Tool
  class Article

    extend Langchain::ToolDefinition
    include Langchain::DependencyHelper

    define_function :create, description: "Article DB Tool: Create a new article via ActiveRecord"

    # Initialize the ArticleTool
    def initialize; end

    def create(
      title:,
      summary:,
      content:,
      author:,
      link:,
      published_date:,
      language:,
      country:,
      country_emoji:
    )
      # This will be converted to string in the DB - no biggie. Easy to reverse.
      hashy_blurb = {
        country:,
        country_emoji:,
        article_tool_version: VERSION
      }
      article = Article.create(
        title: title.force_encoding('UTF-8'),
        summary: summary.force_encoding('UTF-8'),
        content: content.force_encoding('UTF-8'),
        author:,
        link:,
        published_date:,
        language:,
        # guid: SecureRandom.uuid, # maybe link itself
        guid: link,
        newspaper: link.split('/')[2], # https://www.begeek.fr/google -> "www.begeek.fr"
        macro_region: 'gemini-fun-call',
        hidden_blurb: hashy_blurb.to_s,
        ricc_internal_notes: "Created through Andrei's amazing ArticleTool #{NAME} v#{VERSION}.
          parsable_blurb = {
            country: '#{country}',
            country_emoji: '#{country_emoji}',
          }
        ",
        ricc_source: 'Gemini FunctionCalling'
      )

      if article.persisted?
        # { id: article.id }
        # returning the whole object as suggested by Andrei in his video
        # https://drive.google.com/file/d/1U_hStFa3PmphfHM9xuhNM1W4uQdSwgv5/view?resourcekey=0-EE3YdWxYmp0_YgUGgBk9KQ
        article.interesting_attributes # redacting the embeddings ones
      else
        article.errors.full_messages
      end
    end

  end
end
