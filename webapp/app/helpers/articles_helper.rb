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

end
