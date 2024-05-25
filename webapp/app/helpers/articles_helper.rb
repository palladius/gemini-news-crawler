module ArticlesHelper

  def render_article_newspapaer article
    emoji = case article.macro_region
    when 'Italy'
      '🇮🇹'
    when 'Europe'
      '🇪🇺'
    when 'Blogs'
      '🖕🏻'
    when 'Americas', 'USA'
      '🇺🇸'
    when 'gemini-fun-call'
      '♊️' # ♊️ or ♊︎
    else
     "#{article.macro_region} ??"
    end
    #    [<%#=  %>]
    #[<%#= article.newspaper %>]
    #[<%=  %>]
    "#{emoji} #{article.newspaper}"
  end

  def render_embedding_for(article, field)
    embedding = article.send(field)
    return "🪹 nil" if embedding.nil?
    embedding_size = embedding.size rescue 0
    "Embedding[#{embedding_size}]: #{embedding.first(4)}, .."
  end

  def render_sanitized(article, field)
    html_string = article.send(field)
    ActionView::Base.full_sanitizer.sanitize(html_string)
  end

  def render_neighbor_distance(article)
    dist = article.neighbor_distance
    "#{(dist*100).round(1)}"
  end

  def render_article(article)
    # Render title with author, or if missing with newspaper thingy
    addl_info = article.author.nil? ?
      "📰 #{article.newspaper}" :
      "🧑🏻‍💻 #{article.author}"
    short_date =  article.published_date.to_date.strftime('%Y%b%d').gsub(/2024/,'') rescue "?⌚️?" # eg "May 14" or "1997May29"
    link_to('🔗', article.link, class: :link_icon, target: "_blank") + " #{short_date} " + link_to(content_tag('b', article.title), article) + " (" + content_tag('i', addl_info) +")"
  end

end
