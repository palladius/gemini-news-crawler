# frozen_string_literal: true

class SmartQueriesController < ApplicationController
  before_action :set_freshest_article # needed in ALL controllers

  def index
    # return show if params[:query]

    # Sample queries to embed
    # Defined in `app/controllers/smart_queries_controller.rb` :)
    @sample_queries = [
      'US politics',
      'Global warming',
      'European Elections',
#      'Verona, Veneto, Venezia region',
      'Pescara, Italy',
      'Italy',
      'Google Cloud and Alphabet',
      'Android phones',
      'Ruby or Rails',
      # "fun facts",
      'Geopolitical world situation',
      'Latest movies on Netflix',
      'Best travel locations',
      #  'Cronaca Nera',
      'Fake news',
    ]
    # defined in  app/views/pages/assistant.html.erb:@sample_queries_for_gemini_functions_use_controller_instead = [
    # @sample_queries_for_gemini_functions = [
    #   "What's new in US politics?",
    #   "Verona, Veneto, Venezia region",
    #   "latest 5 stories from France",
    #   "latest 4 stories from Oregon",
    #   "Latest stories from Italy?",
    #   "Any news from Google Cloud?",
    #   "Any news about Ruby or RoR?",
    #   "What are some fun stories from headlines?",
    # ]
    @rag_type = 'in show non in index!'
  end

  def show
    @query = params[:query]
    @query_type = params.fetch :type, 'search' # probably search
    @rag_type = params.fetch :rag_type, 'short' # default
  end
end
