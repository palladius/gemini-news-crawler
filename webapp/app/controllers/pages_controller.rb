class PagesController < ApplicationController
  before_action :set_freshest_article # needed in ALL controllers

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

  def chat
  end
end
