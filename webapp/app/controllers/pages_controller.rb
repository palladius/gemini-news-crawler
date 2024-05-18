class PagesController < ApplicationController
  def stats
  end

  def about
  end

  def search
  end

  def demo_news_retriever
  end

  def assistant
    @query = params.fetch(:query, nil)
  end
end
