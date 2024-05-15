# frozen_string_literal: true

class ArticleTool < Langchain::Tool::Base
  NAME = "article_tool"
  ANNOTATIONS_PATH = Pathname.new("#{__dir__}/article_tool.json").to_path

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
  # @return [Hash] the id of the created article
  def create(
    title:,
    summary:,
    content:,
    author:,
    link:,
    published_date:,
    language:
  )
    article = Article.create(
      title: title,
      summary: summary,
      content: content,
      author: author,
      link: link,
      published_date: published_date,
      language: language,
      guid: SecureRandom.uuid,
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
