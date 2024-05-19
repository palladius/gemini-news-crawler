module ApplicationHelper
  def fancy_link_to(a,b)
    # Thanks Gemii
    link_to(a,b, class: 'prose-a underline text-blue-40')
  end

  def fancy_title(title)
#    content_tag(:h1, title, class: 'font-bold text-4xl')
    content_tag(:h1, title, class: "font-bold text-4xl text-gray-800 shadow-lg")
  end
end
