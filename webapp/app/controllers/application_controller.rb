class ApplicationController < ActionController::Base
  before_action :set_carlessian_variables

  def set_carlessian_variables
   # I need it in the footer, hence everywhere..
   @freshest_article = Article.select(&:published_date).sort_by(&:published_date).last(1)[0]
  end

end
