class ApplicationController < ActionController::Base
  before_action :set_carlessian_variables

  def set_carlessian_variables
    # I need it in the footer, hence everywhere..
    @freshest_article = Article.select(&:published_date).sort_by(&:published_date).last(1)[0]

    # caching: https://pawelurbanek.com/rails-active-record-caching
    # @users = Rails.cache.fetch("my_slow_query", expires_in: 1.minute) do
    #   User.slow.to_a
    # end
    @freshest_article_cached = Rails.cache.fetch("freshest_article_cached", expires_in: 5.minute) do
      Article.select(&:published_date).sort_by(&:published_date).last(1)[0]
    end

  end

end
