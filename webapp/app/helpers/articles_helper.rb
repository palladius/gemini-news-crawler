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

end
