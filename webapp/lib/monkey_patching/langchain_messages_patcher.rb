puts("💬💬💬 REMOVEME this file is imported into rails 💬💬💬")

module MonkeyPatching::LangchainMessagesPatcher
  class Langchain::Messages::GoogleGeminiMessage
    def to_s
      # 💬
      # fun call
      if self.tool_calls.any?
        return self.tool_calls.enum_for(:each_with_index).map {|tool_call,ix|
          return "🤖 [#{role}] 🛠️ [#{ix+1}/#{self.tool_calls.count}] 🛠️  #{tool_call['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}"
          # + "DEB #{tool_call.to_s.colorize(:blue)}"
      }.join("ZZZ\nAAA") # test, should just be "\n"
        #return "🤖 [#{role}] 🛠️ #{self.tool_calls[0]['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}" if self.tool_calls.any?
    end
      # model
      return "🤖 [#{role}] 💬 #{self.content.force_encoding("UTF-8").strip.colorize :cyan}" if role == 'model'
      # user
      return "🧑 [#{role}] 💬 #{self.content.force_encoding("UTF-8").colorize :yellow}" if role == 'user'
      # function
      return "🤖 [#{role}] 🛠️  #{self.tool_call_id.force_encoding("UTF-8").colorize :red} => #{self.content.force_encoding("UTF-8").colorize :green}" if role == 'function'
      # if everything else fails...
      self.inspect # :status, :code, :messafe, ...
    end
  end
end
