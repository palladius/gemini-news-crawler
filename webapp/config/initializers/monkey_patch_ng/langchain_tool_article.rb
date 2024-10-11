# TODO(ricc): quando funge spostalo in app/tools/

# Error
#  Langchain::Assistant - Error running tools: missing keywords: :title, :summary, :content, :author, :link, :published_date, :language, :country, :country_emoji; /


# WError2:

module Langchain::Tool
  class RiccardoArticle

    extend Langchain::ToolDefinition
    include Langchain::DependencyHelper

    VERSION = '1.13'
    NAME = 'RiccardoArticle'
    CHANGELOG = <<-TEXT
      TODO(ricc): quando hai un attimo aggiungi il article_tool__delete che ce l'avevi da qualche parte. Certamente ce
      l'hai nel JSON, lho visto.

    v1.13 Added local [rails] url

    v1.12 Added a nice :create with a lot of back and forth to make it work. Last being I forgot this VERISON! :)
            Errors fixed:
        [ERROR]:
          Langchain::Assistant - Error running tools: uninitialized constant Langchain::Tool::RiccardoArticle::VERSION;
          Langchain::Assistant - Error running tools: missing keyword: :published_date; /Users/ricc/git/gemini-news-crawler-modernize/webapp/config/initializers/monkey_patch_ng/langchain_tool_article.rb:43:in `create'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/langchainrb-0.17.1/lib/
          Langchain::Assistant - Error running tools: missing keyword: :published_date; /Users/ricc/git/gemini-news-crawler-modernize/webapp/config/initializers/monkey_patch_ng/langchain_tool_article.rb:43:in `create'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/langchainrb-0.17.1/lib/langchain/assistants/assistant.rb:384:in `block in run_tools'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/langchainrb-0.17.1/lib/langchain/assistants/assistant.rb:377:in `each'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/langchainrb-0.17.1/lib/langchain/assistants/assistant.rb:377:in `run_tools'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/langchainrb-0.17.1/lib/langchain/assistants/assistant.rb:326:in `execute_tools'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/langchainrb-0.17.1/lib/langchain/assistants/assistant.rb:252:in `handle_state'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/langchainrb-0.17.1/lib/langchain/assistants/assistant.rb:134:in `run'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/langchainrb-0.17.1/lib/langchain/assistants/assistant.rb:153:in `add_message_and_run'\n/Users/ricc/git/gemini-news-crawler-modernize/webapp/config/initializers/monkey_patch_ng/riccardo15_monkeypatch_langchain_assistant.rb:12:in `say'\n(irb):27:in `s'\n(irb):63:in `<main>'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb/workspace.rb:121:in `eval'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb/workspace.rb:121:in `evaluate'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb/context.rb:633:in `evaluate_expression'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb/context.rb:601:in `evaluate'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1049:in `block (2 levels) in eval_input'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1388:in `signal_status'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1041:in `block in eval_input'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1120:in `block in each_top_level_statement'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1117:in `loop'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1117:in `each_top_level_statement'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1040:in `eval_input'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1021:in `block in run'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1020:in `catch'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:1020:in `run'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/irb-1.14.0/lib/irb.rb:904:in `start'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/commands/console/console_command.rb:78:in `start'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/commands/console/console_command.rb:16:in `start'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/commands/console/console_command.rb:106:in `perform'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/thor-1.3.1/lib/thor/command.rb:28:in `run'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/thor-1.3.1/lib/thor/invocation.rb:127:in `invoke_command'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/command/base.rb:178:in `invoke_command'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/thor-1.3.1/lib/thor.rb:527:in `dispatch'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/command/base.rb:73:in `perform'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/command.rb:71:in `block in invoke'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/command.rb:149:in `with_argv'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/command.rb:69:in `invoke'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/railties-7.1.3.2/lib/rails/commands.rb:18:in `<main>'\n<internal:/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'\n<internal:/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/3.2.0/rubygems/core_ext/kernel_require.rb>:37:in `require'\n/Users/ricc/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/bootsnap-1.18.4/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:30:in `require'\nbin/rails:6:in `<main>'

      v1.11 Started on 9oct24 to address the new Langchain tool

      v1.10 Added Carlessian url: https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/articles/#id
      v1.9  Got a delete error - tried to perfect the JSON decription

      app/tools/article_tool.rb:94:in `destroy': wrong number of arguments (given 1, expected 0; required keyword: id) (ArgumentError)

      v1.8 Got a create error by unknown city -> defaults now to Vatican.

      app/tools/article_tool.rb:37:in `create': missing keywords: :country, :country_emoji (ArgumentError)

      v1.7 now create() sends a more verbose output in return (whole object instead of just id)
      v1.6 fixed missing `delete` function. Bug:

        (irb):10:in `say': undefined method `delete' for #<ArticleTool:0x00007f97d69cc1b8> (NoMethodError)

      v1.5 Added UTF8 in the code (I trust myself more than an AI :P). Altenratvie would be to sanitize UTF8 in the EXIT of the
          NewsRetriever but that's built into Langchain::Tool::NewsRetriever gem so it would be yet another thing to override.
      v1.4 Added UTF8 in the specs since the output is very ugly now: http://localhost:3000/articles/10334
      v1.3
      v1.2 Add EMOJI so AI finds emoji for me and I can just put somewhere easy to parse :)
      v1.1 GUID is now the Link. Also fixing macro-region
      v1.0 First version from Andrei

    TEXT

    define_function :create, description: "Article DB Tool: Create a new article via ActiveRecord" do
      # Done with
        property :title, type: "string", description: "the title of the article"
        property :summary, type: "string", description: "the summary of the article"
        property :content, type: "string", description: "the content of the article", required: false
        property :author, type: "string", description: "the author of the article", required: false
        property :link, type: "string", description: "the link to the article"
        property :published_date, type: "string", description: "the published date of the article", required: false
        property :language, type: "string", description: "the language of the article", required: false
        property :country, type: "string", description: "the country of the article (whatever that means)", required: false
        property :country_emoji, type: "string", description: "the emoji of the flag of the country chosen", required: false
    end
    define_function :carlessian_url, description: "Article DB Tool: provides Cloud Run article URL (permalink) for the app in the Cloud" do
      property :id, type: "integer", description: "Article numeric id", required: true
    end
    define_function :local_url, description: "Article DB Tool: provides local article URL (permalink) for the Ruby on Rails app in localhost" do
      property :id, type: "integer", description: "Article numeric id", required: true
    end

    # define_function :execute, description: "Database Tool: Executes a SQL query and returns the results" do
    #   property :input, type: "string", description: "SQL query to be executed", required: true
    # end

  # Create a new article
  #
  # @param title [String] the title of the article
  # @param summary [String] the summary of the article
  # @param content [String] the content of the article
  # @param author [String] the author of the article
  # @param link [String] the link to the article
  # @param published_date [String] the published date of the article
  # @param language [String] the language of the article
  # @param country [String] the country of the article (whatever that means)
  # @param country_emoji [String] the emoji of the flag of the country chosen
  # @return [Hash] the id of the created article
  def create(
    title:,
    summary:,
    content: '',
    author:,
    link:,
    published_date: "1970-01-01",
    language:,
    country:,
    country_emoji:
  )
    # This will be converted to string in the DB - no biggie. Easy to reverse.
    hashy_blurb = {
      country:,
      country_emoji:,
      article_tool_version: VERSION
    }
    article = Article.create(
      title: title.force_encoding('UTF-8'),
      summary: summary.force_encoding('UTF-8'),
      content: content.force_encoding('UTF-8'),
      author:,
      link:,
      published_date:,
      language:,
      # guid: SecureRandom.uuid, # maybe link itself
      guid: link,
      newspaper: link.split('/')[2], # https://www.begeek.fr/google -> "www.begeek.fr"
      macro_region: 'gemini-fun-call',
      hidden_blurb: hashy_blurb.to_s,
      ricc_internal_notes: "Created through Andrei's amazing ArticleTool #{NAME} v#{VERSION}.
        parsable_blurb = {
          country: '#{country}',
          country_emoji: '#{country_emoji}',
        }
      ",
      ricc_source: 'Gemini FunctionCalling'
    )

    if article.persisted?
      # { id: article.id }
      # returning the whole object as suggested by Andrei in his video
      # https://drive.google.com/file/d/1U_hStFa3PmphfHM9xuhNM1W4uQdSwgv5/view?resourcekey=0-EE3YdWxYmp0_YgUGgBk9KQ
      article.interesting_attributes # redacting the embeddings ones
    else
      article.errors.full_messages
    end
  end

  # Destroy article by id:
  #
  # @param id [Integer] the id of the article to destroy
  # @return [Boolean] true if the article was destroyed, false otherwise
  def delete(id:)
    article = Article.find(id)
    !!article.destroy
  end

  # We dont need this!
  # def destroy(id:)
  #   destroy(id: id) # Ricc learning
  # end

  def carlessian_url(id:)
    if Rails.env == 'production'
      "https://gemini-news-crawler-prod-x42ijqglgq-ew.a.run.app/articles/#{id}"
    else
      "https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/articles/#{id}"
    end
  end

  # Added recently
  def local_url(id:)
      "http://127.0.0.1:3000/articles/#{id}"
  end

  end # /class
end # /module


# Fixes this:
# Showing /Users/ricc/git/gemini-news-crawler-modernize/webapp/app/views/pages/_assistant_demo_show.html.erb where line #35 raised:
# uninitialized constant #<Class:0x00000001402b1ba0>::ArticleTool
# Extracted source (around line #36):
#article_tool = Langchain::Tool::ArticleTool.new
# article_tool = ArticleTool.new
ArticleTool = Langchain::Tool::RiccardoArticle
