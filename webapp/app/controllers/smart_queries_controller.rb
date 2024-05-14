class SmartQueriesController < ApplicationController
  def index
    # return show if params[:query]
    @sample_queries = [
      "What's up with US politics?",
      "What happens in Verona or in Veneto region?",
      "What are the latest stories?",
      "What are the latest stories from Italy?",
      "Any news from Google Cloud?",
      "Any news about Ruby or RoR?",
      "What are some fun facts?",
    ]
  end

  def show
    @query = params[:query]
    @query_type = params.fetch :type, 'search' # probably search
  end
end
