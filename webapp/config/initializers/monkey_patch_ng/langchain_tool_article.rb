# TODO(ricc): quando funge spostalo in app/tools/

module Langchain::Tool
  class ArticleTool

    extend Langchain::ToolDefinition
    include Langchain::DependencyHelper

    define_function :create, description: "Article DB Tool: Create a new article via ActiveRecord"
#    define_function :create, description: "Article DB Tool: Create a new article via ActiveRecord"
    carlessian_url(id:)

  # Create a new article
  #
  # @param title [String] the title of the article
  # @param summary [String] the summary of the article
  # @param content [String] the content of the article
  # @param author [String] the author of the article
  # @param link [String] the link to the article
  # @param published_date [String] the published date of the article
  # @param language [String] the language of the article
  # @param country [String] the country of the article (whatever that means)
  # @param country_emoji [String] the emoji of the flag of the country chosen
  # @return [Hash] the id of the created article
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

  # Destroy article by id:
  #
  # @param id [Integer] the id of the article to destroy
  # @return [Boolean] true if the article was destroyed, false otherwise
  def delete(id:)
    article = Article.find(id)
    !!article.destroy
  end

  # We dont need this!
  # def destroy(id:)
  #   destroy(id: id) # Ricc learning
  # end

  def carlessian_url(id:)
    if Rails.env == 'production'
      "https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/#{id}"
    else
      "https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/articles/#{id}"
    end
  end




  end # /class
end # /module
