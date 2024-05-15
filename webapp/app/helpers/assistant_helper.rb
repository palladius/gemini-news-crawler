
module AssistantHelper


# def content_tag_with_color(role, msg, role_color = "violet-700", msg_color = "cyan-500")
#   content_tag(:div, class: "flex items-center") do
#     content_tag(:span, render_assistant_role(role), class: "text-#{role_color} mr-2") +
#     content_tag(:span, msg.content.force_encoding("UTF-8").strip, class: "text-#{msg_color}")
#   end
# end

  def content_tag_with_color(role, msg, role_color = "violet-700", msg_color = "cyan-500")
    content_tag(:div, class: "flex items-center") do
      content_tag(:span, render_assistant_role(role), class: "text-#{role_color} mr-2") +
      content_tag(:span, msg.content.force_encoding("UTF-8").strip, class: "text-#{msg_color}")
    end
  end

  def content_tag_for_role(role, msg)
    role_emoji = render_assistant_role(role)
    case role.downcase
    when 'model'
      msg_color = 'cyan-500'
    when 'user'
      msg_color = 'yellow-300' # Adjusted for better visibility on white background
    when 'function'
      msg_color = 'green-500'
      tool_call_id = content_tag(:span, msg.tool_call_id.force_encoding("UTF-8"), class: "text-red-500")
      content = "#{tool_call_id} => #{msg.content.force_encoding("UTF-8")}"
    else
      msg_color = 'gray-500'
    end

    content_tag_with_color(role, content || msg, nil, msg_color) # Pass nil for role_color
  end

  def render_assistant_message(msg)
    # msg is a Langchain::Messages::GoogleGeminiMessage
    raise "render_assistant_message(msg): wrong class" unless msg.is_a?(Langchain::Messages::GoogleGeminiMessage)
    #  class Langchain::Messages::GoogleGeminiMessage
    role = msg.role

    if msg.tool_calls.any?
      return msg.tool_calls.enum_for(:each_with_index).map {|tool_call,ix|
        return "🤖 [#{role}] 🛠️ [#{ix+1}/#{msg.tool_calls.count}] 🛠️  #{tool_call['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}"
        #  + "DEB #{tool_call.to_s.colorize(:blue)}"
      }.join("ZZZ\nAAA") # test, should just be "\n"
      return "🤖 [#{role}] 🛠️ #{msg.tool_calls[0]['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}" if msg.tool_calls.any?
    end

    # vediamo come fa gemini..
    return content_tag_for_role(role, msg)

    # model
    return content_tag("🤖 [#{role}] 💬 #{msg.content.force_encoding("UTF-8").strip.colorize :cyan}") if role == 'model'

    # user
    return "🧑 [#{role}] 💬 #{msg.content.force_encoding("UTF-8").colorize :yellow}" if role == 'user'
    # function
    return "🤖 [#{role}] 🛠️  #{msg.tool_call_id.force_encoding("UTF-8").colorize :red} => #{msg.content.force_encoding("UTF-8").colorize :green}" if role == 'function'
    # if everything else fails...
    msg.inspect # :status, :code, :messafe, ...
  end
#    msg.inspect
#  end

  # def render_assistant_role(role)
  #   # role can be: user, model, function
  #   emoji
  # end

  def render_assistant_role(role)
    case role.downcase
    when 'user'
      # 🤔: Thinking face, representing a user asking a question or seeking information
      # 🗣️: Speaking head, symbolizing a user communicating their needs or thoughts
      # 🙋: Raising hand, indicating a user asking for clarification or help
      "🤔"
    when 'model'
      # 🤖: Robot face, representing an AI model generating responses
      # 🧠: Brain, symbolizing the knowledge and intelligence of a model
      # 💡: Light bulb, signifying a model coming up with a solution or idea
      "🤖"
    when 'function'
      # 🛠️: Hammer and wrench, representing a tool or function being used
      # ⚙️: Gear, symbolizing the inner workings of a function or process
      # ⚡: High voltage, indicating the power and efficiency of a function
      "🛠️"
    else
      # 🤷: Shrugging person, used when the role is unknown or undefined
      "🤷"
    end
  end
end
