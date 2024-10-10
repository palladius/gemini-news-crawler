# TODO(ricc): quando funge spostalo in app/tools/

# Error
#  Langchain::Assistant - Error running tools: missing keywords: :title, :summary, :content, :author, :link, :published_date, :language, :country, :country_emoji; /
module Langchain::Tool
  class RiccardoArticle

    extend Langchain::ToolDefinition
    include Langchain::DependencyHelper

    define_function :create, description: "Article DB Tool: Create a new article via ActiveRecord" do
      # Done with
        property :title, type: "string", description: "the title of the article"
        property :summary, type: "string", description: "the summary of the article"
        property :content, type: "string", description: "the content of the article"
        property :author, type: "string", description: "the author of the article"
        property :link, type: "string", description: "the link to the article"
        property :published_date, type: "string", description: "the published date of the article"
        property :language, type: "string", description: "the language of the article"
        property :country, type: "string", description: "the country of the article (whatever that means)"
        property :country_emoji, type: "string", description: "the emoji of the flag of the country chosen"
    end
    define_function :carlessian_url, description: "Article DB Tool: provides Cloud Run article URL (permalink) for the app in the Cloud" do
      property :id, type: "integer", description: "Article numeric id", required: true
    end

    # define_function :execute, description: "Database Tool: Executes a SQL query and returns the results" do
    #   property :input, type: "string", description: "SQL query to be executed", required: true
    # end

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
