class SmartQueriesController < ApplicationController


  def index
    # return show if params[:query]

    # Sample queries to embed
    @sample_queries = [
      "US politics",
      "Verona, Veneto, Venezia region",
      #"latest stories",
      "Italy",
      "Google Cloud and Alphabet",
      "Ruby or Rails",
      "fun facts",
      #'crime news',       # => cronaca nera
      'Geopolitical situation in China',
      'Best travel locations',
    #  'Cronaca Nera',
      'Fake news',
    ]
    @sample_queries_for_gemini_functions = [
      "What's new in US politics?",
      "Verona, Veneto, Venezia region",
      "latest stories from France",
      "Latest stories from Italy?",
      "Any news from Google Cloud?",
      "Any news about Ruby or RoR?",
      "What are some fun facts?",
    ]
    @rag_type = 'in show non in index!'
  end

  def show
    @query = params[:query]
    @query_type = params.fetch :type, 'search' # probably search
    @rag_type = params.fetch :rag_type, 'short' # default
  end
end
