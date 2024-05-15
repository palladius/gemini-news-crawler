class PagesController < ApplicationController
  def stats
  end

  def about
  end

  def search
  end

  def assistant
    @query = params.fetch(:query, nil)
  end
end
