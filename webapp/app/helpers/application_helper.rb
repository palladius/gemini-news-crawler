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

    # This works but it doesnt iterate through nested hashes.
    hash_string1 = hash.map {|k, v| "  <b>#{k}</b>: #{v}" }.join("\n") # .join("<br/>\n")
  end

  def render_prose(text, options = {})
    classes = ["prose lg:prose-xl mx-auto bg-gray-800 rounded-xl p-8 prose-invert"]
    classes << options[:class] if options[:class] # Add any additional classes

    text ||= '🤷‍♂️ no text'
    content_tag(:article, class: classes.join(' ')) do
      text.to_s.gsub("\n", "<br/>\n").html_safe
    end
  end

  def render_prose_gemini(text, markdown: true)
    # See  https://tailwindcss.com/docs/gradient-color-stops for awesome gradient.
    myclass = "prose lg:prose-xl rounded bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 text-slate-950" # black
    text ||= '♊️ 🤷‍♂️ no text'
    text = text.gsub("\n\n","\n")
    if markdown
      # interpret as markdown and renders it..
      # https://wmc-blog.netlify.app/2022/04/01/markdown-in-ruby-on-rails-with-redcarpet
      options = [:hard_wrap, :autolink, :no_intra_emphasis, :fenced_code_blocks, :underline, :highlight, :no_images, :filter_html, :safe_links_only, :prettify, :no_styles, :superscript, :lax_html_blocks]
      text = Markdown.new(text, *options).to_html.html_safe
    end
    content_tag(:div, text, class: myclass).gsub("\n","<br/>").html_safe
  end



end
