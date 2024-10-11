# frozen_string_literal: true

require 'English'

module Embeddable
  extend ActiveSupport::Concern

  EmbeddableFields = %w[title_embedding summary_embedding article_embedding].freeze # .each do |my_field|

  #   included do
  # #    store_accessor :embeddings, :title_embedding, :summary_embedding
  #     store_accessor :title_embedding, :summary_embedding
  #   end
  def assert_good_gemini_response(x, description)
    raise "assert_good_gemini_response(#{description}): should be an Array, not a '#{x.class}'" unless x.is_a?(Array)
    unless x.size == 768
      raise "assert_good_gemini_response(#{description}): should be an Array sized 768, not #{x.size}"
    end

    true
  end

  def compute_embeddings!
    if gcp?
      # ARRAYs (fake vectors)
      if title.nil? || title.empty?
        puts('ε - No title -> skipping')
      else
        # there was possibly a BIG bug here. Now fixed since version 0.3.1
        e_title = compute_gcp_embeddings_for(field_to_access: :title) # array of 768
        assert_good_gemini_response(e_title, 'compute_embeddings! on title side 1')
        self.title_embedding = e_title # .to_a # This converts to string!!!
        assert_good_gemini_response(title_embedding, 'compute_embeddings! on title side 2 after assignment')
      end

      if summary.nil? || summary.empty?
        puts('ε - No summary -> skipping')
      else
        # raise Empty request - skipping calculation as it doesnt make sense. -> rescue nil
        self.summary_embedding = begin
          compute_gcp_embeddings_for(field_to_access: :summary)
        rescue StandardError
          nil
        end
        assert_good_gemini_response(title_embedding, 'compute_embeddings! on Summary side')
      end
      # VECTOR (the real deal)
      # db/schema.rb:    t.vector "title_embedding", limit: 768
      # db/schema.rb:    t.vector "summary_embedding", limit: 768
      # db/schema.rb:    t.vector "article_embedding", limit: 768
      # OLD VERSION: article_embedding copied from  title_embedding
      # self.article_embedding = self.title_embedding if (self.article_embedding.nil? and  self.title_embedding.is_a? Array)

      # SKIPPING Article side and doing it the Gemini way.
      # self.article_embedding = self.compute_gcp_embeddings_for(field_to_access: :article) rescue nil
      # assert_good_gemini_response(self.article_embedding, "compute_embeddings! on whole Article side")
      puts('Computing ArticleEmbeddings in v2!')
      compute_article_embedding_with_gemini_v2

      save if changed? # cool! https://stackoverflow.com/questions/24412634/rails-save-method-if-no-changes
    else
      puts('GCP is false. Lets compute them through Llama or sth else..')
      #   self.title_embedding = [42,42,42,42,42]
      #   self.summary_embedding = [41.0,41.0,41.0,41.0,41.0]
    end
    self
  end

  # This is a new function from 9oct24 - to restore Demo1 to its antique splendeurs.
  # Unfortunately we had:
  # - title    # v1 - now this (v3?)
  # - summary  # v1 - now this (v3?)
  # - article  # v2 - always worked
  # The problem is that the embeddings of v3 dont seem compatible to v1 by looking at it. Probably it uses a different embedding model
  # #blahblahblahpoo.
  #
  def compute_gcp_embeddings_for(field_to_access: :summary , save_afterwards: false)
    puts("Sorry this function is obsolete and doesnt work anymore. TODO(ricc): upgrade to compute_article_embedding_with_gemini_v2() which works great for article_embeddings!")
    #self.article_embedding = GeminiLLM.embed(text: article).embedding # rescue nil resceu nil

    text_to_embed = send(field_to_access)

    # Compute the embedding
    polymorphic_embedding = GeminiLLM.embed(text: text_to_embed).embedding

    embedding_description = {
      ricc_notes: '[embed-v3] Fixed on 9oct24. Only seems incompatible at first glance with embed v1.',
#      llm_project_id: GeminiLLM.project_id rescue "[unavailable: #{$!}]", # GEmini doesnt have project id - Vertex does!
      llm_dimensions: GeminiLLM.default_dimensions,
      article_size: article.size,
      poly_field: field_to_access.to_s,
      #llm_embedding_model: GeminiLLM.default_dimensions,
      ## Hardcoded
      llm_embeddings_model_name: 'textembedding-gecko', # hardocded in Gemini Monkeypatch - see code
    }

    # Assign the embedding to the corresponding field using `send`
    send("#{field_to_access}_embedding=", polymorphic_embedding)

    send("#{field_to_access}_embedding_description=", embedding_description)
    #self.article_embedding_description = embedding_description.to_s
    save if save_afterwards
    polymorphic_embedding

  end

  def compute_embeddings
    need_to_compute_embedding = title_embedding.nil?
    if need_to_compute_embedding # title_embedding.nil? and summary_embedding.nil?
      puts('Some Embeddings are EMPTY - what I do is now needed!')
      compute_embeddings!
    else
      puts('Some Embeddings are NON EMPTY - I skip all (but TBH I should be iterating through every value...)')
      puts("- 1. title_embedding.nil? -> #{title_embedding.nil?}")
      puts("- 2. summary_embedding.nil? -> #{summary_embedding.nil?}")
      puts("- 3. article_embedding.nil? -> #{article_embedding.nil?}")
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

  # this is the OLD v1 way of calculating an embedding. Uses gemini-ai and a very manual process.
  # def compute_gcp_embeddings_for(field_to_access:)
  #   value = cleanup_text(send(field_to_access)).to_s
  #   raise 'Empty request - skipping calculation as it doesnt make sense.' if value.length <= 1 # also 1 is nothing..

  #   puts("+ Compute embeddings for a #{self.class}. Value: '#{value}'. Len=#{value.length}")
  #   unless gcp?
  #     puts('No GCP enabled. I need to skip this - quitely.')
  #     return
  #   end
  #   require 'gemini-ai'
  #   require 'matrix'

  #   client = Gemini.new(
  #     credentials: {
  #       service: 'vertex-ai-api',
  #       file_path: GCP_KEY_PATH, # 'private/ricc-genai.json' ,
  #       region: 'us-central1' # 'us-east4'
  #     },
  #     # code: https://github.com/gbaptista/gemini-ai/blob/main/controllers/client.rb
  #     options: {
  #       model: EmbeddingModel,
  #       service_version: 'v1'
  #     }
  #   )
  #   request_hash = {
  #     "instances": [{
  #       # "task_type": "QUESTION_ANSWERING", # "Semantic Search", ## "QUESTION_ANSWERING",
  #       "task_type": 'RETRIEVAL_DOCUMENT', # what i need
  #       "content": value
  #     }]
  #   }
  #   result = begin
  #     client.request('predict', request_hash)
  #   rescue StandardError
  #     [$ERROR_INFO, nil]
  #   end
  #   if not result.is_a?(Array) # .nil?
  #     puts("❌ Some issues with #{embedding_model} request: '#{result[0]}' => Exiting")
  #     puts("❌ request_hash: #{request_hash}")

  #     #exit(42) # raise 'TODO levami di qui - ma ora muoro'
  #     return nil
  #   end
  #   File.write('.tmp.hi.embed_predict.json', result.to_json)
  #   # Embedding Response
  #   #binding.pry
  #   print(result.class)
  #   # if not
  #   puts("❌ result['class']: #{result.class}")
  #   puts("❌ result['keys']: #{result.keys}")
  #   return false unless result.key?(:predictions)

  #   cleaned_response = result['predictions'][0]['embeddings']['values']
  #   stats = begin
  #     puts(result)
  #     result['predictions'][0]['embeddings']['statistics']
  #   rescue StandardError
  #     "Some Error: #{$ERROR_INFO}"
  #   end
  #   puts("📊 Stats: #{stats}")
  #   puts("📊 cleaned_response (should be an Array) is a: #{cleaned_response.class}")
  #   puts("♊️ YAY! Gemini Embeddings responded with a #{begin
  #     cleaned_response.size
  #   rescue StandardError
  #     -1
  #   end}-sized embedding: #{begin
  #     cleaned_response.first(3)
  #   rescue StandardError
  #     result
  #   end}, ...")
  #   assert_good_gemini_response(cleaned_response, "End of compute_gcp_embeddings_for(#{field_to_access})")
  #   cleaned_response
  # end

  # This is WRONG
  def similar_articles(max_size: 5, similarity_field: :title_embedding)
    closest_articles(size: max_size, similarity_field:)
    #   raise "similar_articles this is WRONG. pls implement properly using nearest_neighbors from https://github.com/ankane/neighbor"
    #   Article.all.first(5)
  end

  # def fix_strings!(my_field:, save_after_correct_assignment: true)
  #   raise "Unsupported/Unfixable field: #{my_field}" unless EmbeddableFields.include?(my_field.to_s)
  #   val = self.send(my_field)
  #   if val.is_a?(String)
  #     puts("Trying to move String to an Array")
  #     # Dangerous!!!
  #     new_val = eval(val)
  #     raise "Not an array - exiting!" unless new_val.is_a?(Array)
  #     # Now we're good - assignign
  #     # a.send(:c=, b.send(:c))
  #     self.send("#{my_field}=", new_val)
  #     # Now we're good - saving - maybe?
  #     self.save if save_after_correct_assignment
  #   end
  # end

  # def autofix_strings_bug!()
  #   EmbeddableFields.each do |f|
  #     fix_strings!(my_field: f)
  #   end
  # end

  # Sistanbce from another Article by title
  # , field: :title)
  def distance_by_title_from(article)
    # Computes the instance
    # <-> - L2 distance
    # <=> - cosine distance
    # <#> - (negative) inner product
    "
      SELECT
        id,title, title_embedding
      FROM Articles
      ORDER BY title_embedding <=>
      (
       SELECT title_embedding FROM Articles WHERE id=#{article.id}
      )
       LIMIT 5;"
  end

  # Last in DEV:  => {"title_embedding_class"=>String, "summary_embedding_class"=>NilClass, "article_embedding_class"=>Array, "article_embedding_array_len"=>768}
  # Last in PROD: => {"title_embedding_class"=>NilClass, "summary_embedding_class"=>String, "article_embedding_class"=>NilClass}
  def embeddings_palooza
    ret = { env: Rails.env } # boh: 'remove me'
    # title_embedding: nil,
    # summary_embedding: nil,
    # article_embedding: nil>
    %w[title_embedding summary_embedding article_embedding].each do |my_field|
      val = send(my_field)
      ret["#{my_field}_class"] = val.class

      if val.nil?
        ret["#{my_field}_nil"] = true
        original_field = my_field.gsub(/_embedding/, '')
        original_field_value = send(original_field)
        ret["#{my_field}_original_field_nil"] = original_field_value.nil?
        ret["#{my_field}_make_sense_to_compute_embedding"] = !original_field_value.nil?
        ret["#{original_field}_class"] = original_field_value.class
      end

      if val.is_a?(Array)
        ret["#{my_field}_array_len"] = val.length
        ret["#{my_field}_array_sample123"] = [val[0], val[1], val[2]] if val.length == 768
      end
    end
    ret
  end

  # v2 version of embeddings, NOT multilingual.
  # This is done with `GeminiLLM` and `textembedding-gecko`
  def compute_article_embedding_with_gemini_v2(save_afterwards: false)
    # TODO: move out of CLASS
    self.article_embedding = GeminiLLM.embed(text: article).embedding # rescue nil resceu nil
    # if nil, next...
    embedding_description = {
      #llm_project_id: GeminiLLM.project_id,
      llm_dimensions: GeminiLLM.default_dimensions,
      article_size: article.size,
      # llm_embedding_model: GeminiLLM.default_dimensions, cant find it!
      llm_embeddings_model_name: 'textembedding-gecko'
    }
    self.article_embedding_description = embedding_description.to_s
    save if save_afterwards
    self
  end

  # Class Methods: https://stackoverflow.com/questions/33326257/what-does-class-methods-do-in-concerns
  class_methods do
    # EMbeddings which i thought was love instead was a caless...
    def find_all_with_fake_embeddings
      # Article.includes(:title_embedding).where.not('title_embedding' => nil).count
      # https://stackoverflow.com/questions/4252349/rails-where-condition-using-not-nil
      includes(:title_embedding).where.not('title_embedding' => nil).all # count
    end

    # Proper EMbeddings which are from VECTOR
    def find_all_with_proper_embeddings
      # Article.includes(:title_embedding).where.not('title_embedding' => nil).count
      # https://stackoverflow.com/questions/4252349/rails-where-condition-using-not-nil
      includes(:article_embedding).where.not('article_embedding' => nil).all # count
    end

    def find_all_without_any_embeddings
      #      self.includes(:article_embedding).where('article_embedding' => nil).all
      where('article_embedding' => nil).all
    end

    def find_all_with_empty_date
      where('published_date' => nil).all
    end

    def compute_embeddings_for_all(max_instances: 10_000)
      puts("🗿🗿🗿 Computing embeddings for ALL. This makes for a great RAKE task or a Job (inspired by 'DHH-Vanilla-RoR7 with Embeddings')!")
      how_many = find_all_without_any_embeddings.count
      puts("🗿🗿🗿  Total Articles: #{Article.all.count}. Total embeddings to be computed: #{how_many}")
      find_all_without_any_embeddings.each_with_index do |article, ix|
        puts("🗿 [#{ix + 1}/#{how_many}] Calculating embedding for #{article}..")
        break if ix > max_instances

        article.compute_embeddings
        # or the API will complain
        # sleep(1.0/24.0)
        sleep(1.0 / 48.0)
      end
    end

    def migrate_all_article_embedding_to_gemini_thru_langchain(max_instances: 10)
      puts("🗿2️⃣🗿 Computing article_embeddings only (v2) for ALL Articles. This makes for a great RAKE task or a Job (inspired by 'DHH-Vanilla-RoR7 with Embeddings')!")
      embeddings_to_be_recalculated = where('article_embedding_description' => nil).all
      puts("🗿2️⃣🗿 Total Articles: #{Article.all.count}. Total embeddings to be computed (article_embedding_description=nil): #{embeddings_to_be_recalculated.count}")
      embeddings_to_be_recalculated.each_with_index do |a, ix|
        # Now I recompute JUST the article thingy since its RICHER and NEWER and i can keep using the TITLE one on the other thingy until its all migrated.
        # so the OLD keeps working (in the yellow NEIGHBOR articles) until i have sth better for everyone
        break if ix > max_instances

        a.compute_article_embedding_with_gemini_v2
        ret = a.save # FUNGE! Allora devo ricalcolare tutto cacchio.
        puts("Saved Article: #{ret.class}")
        sleep(1.0 / 48.0)
      end
    end

    # summary: nil,
    # content: nil,
    # author: nil,
    # => WTF? Lets get rid of them
    def delete_bad_articles
      Article.where('published_date' => nil).where('content' => nil).where('summary' => nil).delete_all # .allfind_all_with_empty_date
      Article.where('published_date' => nil).delete_all # .allfind_all_with_empty_date
    end
  end
end
