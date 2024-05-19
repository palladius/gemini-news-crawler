module ApplicationHelper
  def fancy_link_to(a,b)
    # Thanks Gemii
    link_to(a,b, class: 'prose-a underline text-blue-40')
  end

  def fancy_title(title)
    # Original boring
    #    content_tag(:h1, title, class: 'font-bold text-4xl')
    # Gemini v1 - carino
    #content_tag(:h1, title, class: "font-bold text-4xl text-gray-800 shadow-lg")
    # Gemini v2
    content_tag(:h1, title, class: "font-bold text-4xl bg-gradient-to-r from-pink-500 to-orange-500 bg-clip-text text-transparent shadow-md")
  end
end
