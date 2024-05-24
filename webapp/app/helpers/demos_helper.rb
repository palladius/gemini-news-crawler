module DemosHelper

  # def demo_button_link(demo_id, color)
  #   link_to("COOL Demo #{demo_id}", "https://github.com/palladius/gemini-news-crawler/blob/main/webapp/docs/demo/demo#{demo_id}-rails-console.rb")

  # end

  # usage: <%= demo_button_link('03', 'yellow-500', 'yellow-700') %>
  # def demo_button_link(demo_id, bgcolor, hover_bgcolor=nil)
  #   base_classes = "text-white font-bold py-2 px-4 rounded"
  #   hover_bgcolor ||= bgcolor # no hover effect if developer is lazy like me :)

  #   link_to("Demo #{demo_id}",
  #     "https://github.com/palladius/gemini-news-crawler/blob/main/webapp/docs/demo/demo#{demo_id}-rails-console.rb",
  #     class: "bg-#{bgcolor} hover:bg-#{hover_bgcolor} #{base_classes}")
  # end

  # v3 usage:
  #   <%= demo_button_link('01', 'blue') %>
  # <%= demo_button_link('02', 'red') %>
  # <%= demo_button_link('03', 'green') %>
  def demo_button_link(demo_id, color)
    color_classes = {
      'blue' => 'bg-[#4285F4] hover:bg-[#3367D6]', # Google blue
      'red' => 'bg-[#EA4335] hover:bg-[#C23321]', # Google red
      'green' => 'bg-[#34A853] hover:bg-[#288741]', # Google green
      'yellow' => 'bg-[#FBBC05] hover:bg-[#F29E02]', # Google yellow (optional)
    }

    base_classes = "text-white font-bold py-2 px-4 rounded"

    link_to("💻 Demo #{demo_id} on github", "https://github.com/palladius/gemini-news-crawler/blob/main/webapp/docs/demo/demo#{demo_id}-rails-console.rb", class: "#{color_classes[color]} #{base_classes}")
  end

end
