module Embeddable
  extend ActiveSupport::Concern

#   included do
# #    store_accessor :embeddings, :title_embedding, :summary_embedding
#     store_accessor :title_embedding, :summary_embedding
#   end
  def assert_good_gemini_response(x, description)
    raise "assert_good_gemini_response(#{description}): should be an Array, not a '#{x.class}'" unless x.is_a?(Array)
    raise "assert_good_gemini_response(#{description}): should be an Array sized 768, not #{x.size}" unless x.size == 768
    true
  end

  def compute_embeddings!()
    if (gcp?)
      # ARRAYs (fake vectors)
      unless self.title.nil? || self.title.empty?
        title = self.compute_gcp_embeddings_for(field_to_access: :title) # rescue nil # Array opf 768.
        assert_good_gemini_response(title, "compute_embeddings! on title side 1")
        self.title_embedding = title # .to_a # This converts to string!!!
        #self.title_embedding = [1,2,3] # title.to_a # This converts to string!!!
        #         title_embedding: "[1, 2, 3]",
        #  summary_embedding: nil,
        #  article_embedding:
        #   [1.0,
        #    2.0,
        #    3.0,
        # Found the bug! title_embedding is a string, not an array!
        assert_good_gemini_response(self.title_embedding, "compute_embeddings! on title side 2 after assignment")
        # irb(main):004> t.class
        # => Array
        # irb(main):005> t.size
        # => 768
      else
        puts("ε - No title -> skipping")
      end

      unless self.summary.nil? || self.summary.empty?
        # raise Empty request - skipping calculation as it doesnt make sense. -> rescue nil
        self.summary_embedding = self.compute_gcp_embeddings_for(field_to_access: :summary) rescue nil
        assert_good_gemini_response(self.title_embedding, "compute_embeddings! on Summary side")
      else
        puts("ε - No summary -> skipping")
      end
      # VECTOR (the real deal)
      # db/schema.rb:    t.vector "title_embedding", limit: 768
      # db/schema.rb:    t.vector "summary_embedding", limit: 768
      # db/schema.rb:    t.vector "article_embedding", limit: 768
      self.article_embedding = self.title_embedding if (self.article_embedding.nil? and  self.title_embedding.is_a? Array)
      self.save if self.changed? # cool! https://stackoverflow.com/questions/24412634/rails-save-method-if-no-changes
    else
      puts("GCP is false. Lets compute them through Llama or sth else..")
    #   self.title_embedding = [42,42,42,42,42]
    #   self.summary_embedding = [41.0,41.0,41.0,41.0,41.0]
    end
    return self
  end

  def compute_embeddings()
    need_to_compute_embedding = title_embedding.nil?
    if need_to_compute_embedding # title_embedding.nil? and summary_embedding.nil?
      puts("Some Embeddings are EMPTY - what I do is now needed!")
      compute_embeddings!
    else
      puts("Some Embeddings are NON EMPTY - I skip all (but TBH I should be iterating through every value...)")
      puts("- title_embedding.nil? -> #{title_embedding.nil?}")
      puts("- summary_embedding.nil? -> #{summary_embedding.nil?}")
    end
  end

  def cleanup_text(text_with_maybe_some_html)
    # Cleanup text - TODO
    # require 'nokogiri'
    # # Assuming you have the HTML content in a variable called 'html_content'
    # doc = Nokogiri::HTML(html_content)
    # # Extract all text nodes, excluding script and style tags
    # text = doc.text.gsub(/\s+/, ' ')  # Remove extra spaces
    # # Alternatively, extract text from specific elements
    # # title_text = doc.at_css('title').text  # Get text from title tag
    # # body_text = doc.at_css('body').inner_text  # Get text from body tag
    text_with_maybe_some_html
  end

  # self.
  def compute_gcp_embeddings_for(field_to_access:)
    value = cleanup_text(self.send(field_to_access)).to_s
    raise "Empty request - skipping calculation as it doesnt make sense." if value.length <= 1 # also 1 is nothing..
    puts("Compute embeddings for a #{self.class}. Value: '#{value}'. Len=#{value.length}")
    unless gcp?
      puts("No GCP enabled. I need to skip this - quitely.")
      return
    end
    require 'gemini-ai'
    require 'matrix'

    embedding_model =  'textembedding-gecko-multilingual'
    client = Gemini.new(
      credentials: {
        service: 'vertex-ai-api',
        file_path: GCP_KEY_PATH, # 'private/ricc-genai.json' ,
        region: 'us-central1', # 'us-east4'
      },
          # code: https://github.com/gbaptista/gemini-ai/blob/main/controllers/client.rb
      options: {
              model:  embedding_model, #  'textembedding-gecko-multilingual',
              service_version: 'v1',
            }
    )
    request_hash = {
      "instances": [{
        #"task_type": "QUESTION_ANSWERING", # "Semantic Search", ## "QUESTION_ANSWERING",
        "task_type": 'RETRIEVAL_DOCUMENT', # what i need
        "content": value
      }],
    # "parameters": {
    #  "outputDimensionality": 256 # 768 is the default
    # }
    }
    result = client.request('predict',request_hash ) rescue [$!, nil]
    if result.is_a? Array # .nil?
      puts("❌ Some issues with #{embedding_model} request: '#{result[0]}' => Exiting")
      puts("❌ request_hash: #{request_hash}")

      exit(42) # raise 'TODO levami di qui - ma ora muoro'
      return nil
    end
    File.write('.tmp.hi.embed_predict.json', result.to_json)
    # Embedding Response
    cleaned_response = result['predictions'][0]['embeddings']['values']
    stats = result['predictions'][0]['embeddings']['statistics'] rescue "Some Error: #{$!}"
    puts("📊 Stats: #{stats}")
    puts("📊 cleaned_response (should be an Array) is a: #{cleaned_response.class}")
    puts("♊️ YAY! Gemini Embeddings responded with a #{cleaned_response.size rescue -1 }-sized embedding: #{cleaned_response.first(3) rescue result}, ...")
    assert_good_gemini_response(cleaned_response, "End of compute_gcp_embeddings_for(#{field_to_access})")
    return cleaned_response
  end

  def similar_articles(max_size: 5)
    Article.all.first(5)
    #[]
  end

  # Sistanbce from another Article by title
  def distance_by_title_from(article) # , field: :title)
    # Computes the instance
    # <-> - L2 distance
    # <=> - cosine distance
    # <#> - (negative) inner product
    query = "
      SELECT
        id,title, title_embedding
      FROM Articles
      ORDER BY title_embedding <=>
      (
       SELECT title_embedding FROM Articles WHERE id=3901
      )
       LIMIT 5;"
  end

  # Class Methods: https://stackoverflow.com/questions/33326257/what-does-class-methods-do-in-concerns
  class_methods do
    # EMbeddings which i thought was love instead was a caless...
    def find_all_with_fake_embeddings()
      #Article.includes(:title_embedding).where.not('title_embedding' => nil).count
      # https://stackoverflow.com/questions/4252349/rails-where-condition-using-not-nil
      self.includes(:title_embedding).where.not('title_embedding' => nil).all # count
    end

    # Proper EMbeddings which are from VECTOR
    def find_all_with_proper_embeddings()
      #Article.includes(:title_embedding).where.not('title_embedding' => nil).count
      # https://stackoverflow.com/questions/4252349/rails-where-condition-using-not-nil
      self.includes(:article_embedding).where.not('article_embedding' => nil).all # count
    end
    def find_all_without_any_embeddings()
#      self.includes(:article_embedding).where('article_embedding' => nil).all
      self.where('article_embedding' => nil).all
    end
    def compute_embeddings_for_all(max_instances: 1000)
      # TODO honour the 1000.
      puts("🗿🗿🗿 Computing embeddings for ALL. This makes for a great RAKE task or a Job (inspired by 'DHH-Vanilla-RoR7 with Embeddings')!")
      #self.all
      how_many = self.find_all_without_any_embeddings.count
      puts("🗿🗿🗿  Total Articles: #{Article.all.count}. Total embeddings to be computed: #{how_many}")
      self.find_all_without_any_embeddings.each_with_index do |article, ix|
        puts("🗿 [#{ix+1}/#{how_many}] Calculating embedding for #{article}..")
        break if ix > max_instances
        article.compute_embeddings()
        # or the API will complain
        sleep(1.0/24.0)
      end
    end
  end
end
