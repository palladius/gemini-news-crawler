class ApplicationController < ActionController::Base
  #include SetCurrentRequestDetails # Enable IAP once you have devise.

  #before_action :set_carlessian_variables # needed only in Article controllers
  #before_action :set_freshest_article # needed in ALL controllers

  # @cache_expiry = Rails.env == 'development' ?
  #   10.seconds : # for dev
  #   10.minutes # for prod

  # def well_done_fresh_article_cached()
  #   cache_str = "freshest_article::v#{APP_VERSION}"
  #   Rails.cache.fetch(cache_str, expires_in: 12.hours) do
  #     #Article.select(&:published_date).pluck(:id, :title).sort_by(&:published_date).limit(10) # last(1)[0]
  #     # super fast, 10 recent-est Articles
  #     Article.select(:id, :title, :published_date).order(:published_date).last(10)
  #   end
  # end


    # caching: https://pawelurbanek.com/rails-active-record-caching
    # Note: I foujd out many of these functions are SLOW *AF*.
    def set_carlessian_variables
      @cache_expiry = Rails.env == 'development' ?
        10.seconds : # for dev
        10.minutes # for prod
    # return if (@set_carlessian_variables_onlyonce == 42 rescue false)
    # @set_carlessian_variables_onlyonce ||= 42
    # @set_carlessian_variables_onlyonce += 1

    puts("ApplicationController::set_carlessian_variables(@set_carlessian_variables_onlyonce=#{@set_carlessian_variables_onlyonce}): Cacheato sta cippa!".colorize :yellow)

    # I need it in the footer, hence everywhere..
#    @freshest_article = Article.select(&:published_date).sort_by(&:published_date).last(1)[0]


    @cached_latest_n_articles ||= Rails.cache.fetch("latest_n_articles::v#{APP_VERSION}", expires_in: @cache_expiry ) do
      # This takes 7.1sec on Derek
      #Article.sensible.select(:published_date).order(:published_date).last(50).reverse # DESC
      # This takes only
      Article.sensible.select_sensible_columns.order(:published_date).last(50) # DESC
    end

    @cached_latest_few_articles ||= Rails.cache.fetch("latest_few_articles", expires_in: @cache_expiry ) do
      # takes 6.7sec
        #Article.sensible.select(&:published_date).sort_by(&:published_date).last(10).reverse # DESC
        # faster 46ms
        Article.sensible.select_sensible_columns.order(:published_date).last(10) # LATEST
      end

    @article_regions ||= Rails.cache.fetch("article_regions", expires_in: 60.minute) do
      #Article.sensible.all.map{|x|x.macro_region}.sort.uniq
      # 48ms
      Article.pluck(:macro_region).uniq
    end
  end

  def set_freshest_article
      # Not cached
      @freshest_article = Article.select_sensible_columns.order(:published_date).last

      @freshest_article_cached ||= Rails.cache.fetch("freshest_article::v#{APP_VERSION}", expires_in: @cache_expiry ) do
        # this takes 6 seconds!
        #Article.sensible.select(&:published_date).sort_by(&:published_date).last(1)[0]
        # this is much faster - 54ms
        #Article.sensible.select(:published_date).order(:published_date).last
        Article.sensible.select_sensible_columns.order(:published_date).last
      end
  end

end
