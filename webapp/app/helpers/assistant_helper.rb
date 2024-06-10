# frozen_string_literal: true

require 'English'
module AssistantHelper
  # def content_tag_with_color(role, msg, role_color = "violet-700", msg_color = "cyan-500")
  #   content_tag(:div, class: "flex items-center") do
  #     content_tag(:span, render_assistant_role(role), class: "text-#{role_color} mr-2") +
  #     content_tag(:span, msg.content.force_encoding("UTF-8").strip, class: "text-#{msg_color}")
  #   end
  # end

  def content_tag_with_color(role, msg, role_color = 'violet-700', msg_color = 'cyan-500')
    content = begin
      msg.content
    rescue StandardError
      msg.inspect
    end
    ret = content_tag(:div, class: 'flex items-center') do
      content_tag(:span, render_assistant_role(role), class: "text-#{role_color} mr-2").html_safe +
        content_tag(:span, content.force_encoding('UTF-8').strip, class: "text-#{msg_color}").html_safe
    end
    article_id_scan = content.scan(/{:id=>(\d+)}/) # => [["10342"]]
    if (article_id_scan.size == 1) && article_id_scan[0].is_a?(Array)
      article_id = article_id_scan[0][0]
      url = url_for(controller: 'articles', action: 'show', id: article_id)
      ret += "<b>Bingo! We just created a new 📰 Article! 🔗🔗🔗 #{link_to "##{article_id}", url} 🔗🔗🔗 </b>".html_safe
    end
    ret.html_safe
  end

  # render_assistant_message ERR: undefined method `content' for "<span class=\"text-red-500\">article_tool__create</span> => [\"Title has already been taken\", \"Guid has already been taken\"]":String

  def content_tag_for_role(role, msg)
    render_assistant_role(role)
    case role.downcase
    when 'model'
      msg_color = 'cyan-500'
    # custom_content = msg.content
    when 'user'
      msg_color = 'yellow-300' # Adjusted for better visibility on white background
    # custom_content = msg.content
    when 'function'
      msg_color = 'green-500'
      tool_call_id = content_tag(:span, msg.tool_call_id.force_encoding('UTF-8'), class: 'text-red-500')
      tool_msg_content = begin
        msg.content.force_encoding('UTF-8')
      rescue StandardError
        msg.inspect
      end
      custom_content = "#{tool_call_id} ==> #{tool_msg_content}"
    else
      msg_color = 'gray-500'
    end
    content_tag_with_color(role, custom_content || msg, nil, msg_color).html_safe # Pass nil for role_color
  end

  def render_assistant_message(msg)
    # msg is a Langchain::Messages::GoogleGeminiMessage
    unless msg.is_a?(Langchain::Messages::GoogleGeminiMessage)
      raise "render_assistant_message(msg): wrong class (should be a Langchain::Messages::GoogleGeminiMessage and is instead a #{msg.class})"
    end

    #  class Langchain::Messages::GoogleGeminiMessage
    role = msg.role

    if msg.tool_calls.any?
      return # test, should just be "\n"
      msg.tool_calls.enum_for(:each_with_index).map do |tool_call, ix|
        return "🤖 [#{role}] 🛠️ [#{ix + 1}/#{msg.tool_calls.count}] 🛠️  #{begin
          tool_call['functionCall'].to_s.force_encoding('UTF-8').colorize(:gray)
        rescue StandardError
          $ERROR_INFO
        end}"
        #  + "DEB #{tool_call.to_s.colorize(:blue)}"
      end.join("ZZZ\nAAA")
      if msg.tool_calls.any?
        return "🤖 [#{role}] 🛠️ #{begin
          msg.tool_calls[0]['functionCall'].to_s.force_encoding('UTF-8').colorize(:gray)
        rescue StandardError
          $ERROR_INFO
        end}"
      end
    end

    # vediamo come fa gemini..
    content_tag_for_role(role, msg).html_safe

    # # 🤖 model
    # return content_tag("💬 #{msg.content.force_encoding("UTF-8").strip.colorize :cyan}") if role == 'model'

    # # user
    # return "🧑 [#{role}] 💬 #{msg.content.force_encoding("UTF-8").colorize :yellow}" if role == 'user'
    # # function
    # return "🤖 [#{role}] 🛠️  #{msg.tool_call_id.force_encoding("UTF-8").colorize :red} => #{msg.content.force_encoding("UTF-8").colorize :green}" if role == 'function'
    # # if everything else fails...
    # msg.inspect # :status, :code, :messafe, ...
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
      '🤔'
    when 'model'
      # 🤖: Robot face, representing an AI model generating responses
      # 🧠: Brain, symbolizing the knowledge and intelligence of a model
      # 💡: Light bulb, signifying a model coming up with a solution or idea
      '🤖'
    when 'function'
      # 🛠️: Hammer and wrench, representing a tool or function being used
      # ⚙️: Gear, symbolizing the inner workings of a function or process
      # ⚡: High voltage, indicating the power and efficiency of a function
      '🛠️'
    else
      # 🤷: Shrugging person, used when the role is unknown or undefined
      '🤷'
    end
  end
end
