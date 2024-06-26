# frozen_string_literal: true

require 'English'
require 'gemini-ai'

# ../private/geminews-gcs-readwriter-key.json
client = Gemini.new(
  credentials: {
    service: 'vertex-ai-api',
    file_path: '../private/geminews-gcs-readwriter-key.json',
    #    region: 'us-east4'
    region: 'us-central1'
  },
  options: { model: 'gemini-pro', server_sent_events: true }
)

# client = Gemini.new(
#   credentials: {
#     service: 'vertex-ai-api',
#     region: 'us-east4'
#   },
#   options: { model: 'gemini-pro', server_sent_events: true }
# )

result = client.stream_generate_content({
                                          contents: { role: 'user', parts: { text: 'hi!' } }
                                        })
# puts(result)
# puts(result.class)
concatenated_ret = ''
result.each do |res|
  begin
    res.dig('candidates', 0, 'content', 'role')
  rescue StandardError
    "Err: #{$ERROR_INFO}"
  end
  extracted_text = begin
    res.dig('candidates', 0, 'content', 'parts', 0, 'text').strip
  rescue StandardError
    "Err: #{$ERROR_INFO}"
  end
  # puts("[#{extracted_role}] #{extracted_text}" ) if extracted_text.length > 0
  concatenated_ret << extracted_text
end
puts("♊ #{concatenated_ret}")
