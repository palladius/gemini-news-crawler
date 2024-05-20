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

  # This renders a JSON string.
  def render_json(str)
    return str.to_s unless str.is_a? Hash
    # Hash
    # str.to_s.gsub ',"','<'
    hash = str

    # This works but it doesnt iterates through nested hashes.
    hash_string1 = hash.map {|k, v| "  <b>#{k}</b>: #{v}" }.join("\n") # .join("<br/>\n")

    #html_string2 = hash.to_s.gsub(/^  (.+?): (.+)$/) { "<p>\\1: \\2</p>" }
    #hash = {"status":"ok","totalResults":39,"articles":[{"source":{"id":null,"name":"Corriere.it"},"author":"Luciano Ferraro","title":"L’ex premier-vignaiolo D’Alema: sì al vino senza alcol, ma non lo berrò","description":"Incontro-degustazione al Vinitaly con lo chef Cracco, il calciatore Barzagli e l’attrice Carole Bouquet","url":"https://www.corriere.it/cook/wine-cocktail/blog-divini/24_aprile_18/ex-premier-vignaiolo-d-alema-si-vino-senza-alcol-ma-non-berro-2e378286-fd62-11ee-a07c-0b5793220589.shtml","u]"}

    #hash_string = hash.map { |k, v| "  #{k}: #{v}" }.join("\n")
#    html_string = hash_string.gsub(/^  (.+?): (.+)$/) { "<p>\\1: \\2</p>" }
    #hash_string = hash_string.gsub(/^  (.+?): (.+)$/) { "<p>\\1: \\2</p>" }
    #hash_string

    #puts html_string  # This will print the formatted HTML string

  end

  def render_prose(text, options = {})
    classes = ["prose lg:prose-xl mx-auto bg-gray-800 rounded-xl p-8 prose-invert"]
    classes << options[:class] if options[:class] # Add any additional classes

    text ||= '🤷‍♂️ no text'
    content_tag(:article, class: classes.join(' ')) do
      text.to_s.gsub("\n", "<br/>\n").html_safe
    end
  end

  def render_prose_gemini(text)
    # See  https://tailwindcss.com/docs/gradient-color-stops for awesome gradient.
    myclass = "prose lg:prose-xl rounded bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500"
    text ||= '♊️ 🤷‍♂️ no text'
    #text = text.gsub("\n","<br/>\n")
    content_tag(:div, text, class: myclass).gsub("\n","<br/>\n").html_safe
  end

end
