class ApplicationController < ActionController::Base
  #include SetCurrentRequestDetails # Enable IAP once you have devise.

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

    @cached_latest_n_articles = Rails.cache.fetch("latest_n_articles_cached", expires_in: 10.minute) do
      Article.select(&:published_date).sort_by(&:published_date).last(50).reverse # DESC
    end

    @cached_latest_few_articles = Rails.cache.fetch("latest_few_articles_cached", expires_in: 1.minute) do
        Article.select(&:published_date).sort_by(&:published_date).last(10).reverse # DESC
      end

    @article_regions = Rails.cache.fetch("article_regions", expires_in: 60.minute) do
      Article.all.map{|x|x.macro_region}.sort.uniq
    end

  end

end
