module Embeddable
  extend ActiveSupport::Concern

#   included do
# #    store_accessor :embeddings, :title_embedding, :summary_embedding
#     store_accessor :title_embedding, :summary_embedding
#   end

  def compute_embeddings!()
    if (gcp?)
      self.title_embedding = self.compute_gcp_embeddings_for(field_to_access: :title)
      self.summary_embedding = self.compute_gcp_embeddings_for(field_to_access: :summary)
      #TODO self.summary_embedding = compute_gcp_embeddings_for(text: self.summary)
      self.save if self.changed? # cool! https://stackoverflow.com/questions/24412634/rails-save-method-if-no-changes
    else
      self.title_embedding = [42,42,42,42,42]
      self.summary_embedding = [41.0,41.0,41.0,41.0,41.0]
    end
    return self
  end

  def compute_embeddings()
    if title_embedding.nil? and summary_embedding.nil?
      puts("Embeddings are EMPTY - what I do is now needed!")
      compute_embeddings!
    else
      puts("Some Embeddings are NON EMPTY - I skip all (but TBH I should be iterating through eveyr value...)")
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
    value = cleanup_text(self.send(field_to_access))
    puts("Compute embeddings for a #{self.class}. Value: '#{value}'")
    unless gcp?
      puts("No GCP enabled. I need to skip this - quitely.")
      return
    end
    require 'gemini-ai'
    require 'matrix'

    #model =  'textembedding-gecko-multilingual'
    client = Gemini.new(
      credentials: {
        service: 'vertex-ai-api',
        file_path: GCP_KEY_PATH, # 'private/ricc-genai.json' ,
        region: 'us-central1', # 'us-east4'
      },
          # code: https://github.com/gbaptista/gemini-ai/blob/main/controllers/client.rb
      options: {
              model:   'textembedding-gecko-multilingual',
              service_version: 'v1',
            }
    )
    request_hash = {
      "instances": [{
        #"task_type": "QUESTION_ANSWERING", # "Semantic Search", ## "QUESTION_ANSWERING",
        "content": value
      }],
    # "parameters": {
    #  "outputDimensionality": 256 # 768 is the default
    # }
    }
    result = client.request('predict',request_hash )
    File.write('.tmp.hi.embed_predict.json', result.to_json)
    # Embedding Response
    cleaned_response = result['predictions'][0]['embeddings']['values']
    puts("📊 Statistics: #{ result['predictions'][0]['embeddings']['statistics'] rescue "Some Error: #{$!}"}")
    puts("♊️ Gemini Embeddings responded with a #{cleaned_response.size rescue -1 }-sized embedding: #{cleaned_response.first(5) rescue result}, ...")
    return cleaned_response
  end

  # Class Methods: https://stackoverflow.com/questions/33326257/what-does-class-methods-do-in-concerns
  class_methods do
    def find_all_with_embeddings()
      #Article.includes(:title_embedding).where.not('title_embedding' => nil).count
      # https://stackoverflow.com/questions/4252349/rails-where-condition-using-not-nil
      self.includes(:title_embedding).where.not('title_embedding' => nil).all # count
    end

    def compute_embeddings_for_all()
      puts("Computing embeddings for ALL. This makes for a great RAKE task!")
      self.all.first(5).each do |article|
        puts("Calculating embedding for #{article}..")
        article.compute_embeddings()
      end
    end
  end
end
