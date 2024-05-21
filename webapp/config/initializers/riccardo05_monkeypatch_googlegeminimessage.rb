class Langchain::Messages::GoogleGeminiMessage
  def to_s
    # 💬
    # fun call
    if self.tool_calls.any?
      # for every tool_calls print one line:
      # 🤖 [model] 🛠️ [1/2] 🛠️  {"name"=>"news_retriever__get_top_headlines", ..
      # 🤖 [model] 🛠️ [2/2] 🛠️  {"name"=>"....",
      return self.tool_calls.enum_for(:each_with_index).map {|tool_call,ix|
        return "🤖 [#{role}] 🛠️ [#{ix+1}/#{self.tool_calls.count}] 🛠️  #{tool_call['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}"
    }.join("\n") # test, should just be "\n"
      #return "🤖 [#{role}] 🛠️ #{self.tool_calls[0]['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}" if self.tool_calls.any?
  end

  redaction_length = 3000
  sanitized_content = self.content.force_encoding("UTF-8").strip
  sanitized_content = sanitized_content.first(redaction_length) + '.. (🤥 redacted)' if sanitized_content.length > redaction_length

    # model
    return "🤖 [#{role}] 💬 #{sanitized_content.colorize :cyan}" if role == 'model'
    # user
    return "🧑 [#{role}] 💬 #{sanitized_content.colorize :yellow}" if role == 'user'
    # function 🖩 would be great but too small 🧮 this is nice
    return "🔢➡️🔢 [#{role}] 🛠️  #{self.tool_call_id.force_encoding("UTF-8").colorize :white} => #{sanitized_content.colorize :gray}" if role == 'function'
    # if everything else fails...
    self.inspect # :status, :code, :messafe, ...
  end
end
