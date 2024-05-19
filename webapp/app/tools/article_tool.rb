# frozen_string_literal: true

class ArticleTool < Langchain::Tool::Base
  NAME = "article_tool"
  ANNOTATIONS_PATH = Pathname.new("#{__dir__}/article_tool.json").to_path
  VERSION = '1.5'

  # v1.5 Added UTF8 in the code (I trust myself more than an AI :P). Altenratvie would be to sanitize UTF8 in the EXIT of the
  #      NewsRetriever but that's built into Langchain::Tool::NewsRetriever gem so it would be yet another thing to override.
  # v1.4 Added UTF8 in the specs since the output is very ugly now: http://localhost:3000/articles/10334
  # v1.3
  # v1.2 Add EMOJI so AI finds emoji for me and I can just put somewhere easy to parse :)
  # v1.1 GUID is now the Link. Also fixing macro-region
  # v1.0 First version from Andrei

  # Initialize the ArticleTool
  def initialize
  end

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
      country: country,
      country_emoji: country_emoji,
      article_tool_version: VERSION,
    }
    article = Article.create(
      title: title.force_encoding("UTF-8"),
      summary: summary.force_encoding("UTF-8"),
      content: content.force_encoding("UTF-8"),
      author: author,
      link: link,
      published_date: published_date,
      language: language,
      #guid: SecureRandom.uuid, # maybe link itself
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
      ricc_source: 'Gemini FunctionCalling',
    )

    if article.persisted?
      { id: article.id }
    else
      article.errors.full_messages
    end
  end

  # Destroy article by id:
  #
  # @param id [Integer] the id of the article to destroy
  # @return [Boolean] true if the article was destroyed, false otherwise
  def destroy(id:)
    article = Article.find(id)
    !!article.destroy
  end
end
