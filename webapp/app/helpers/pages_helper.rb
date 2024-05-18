module PagesHelper
  def render_prose(text, options = {})
    classes = ["prose lg:prose-xl mx-auto bg-gray-800 rounded-xl p-8 prose-invert"]
    classes << options[:class] if options[:class] # Add any additional classes

    text ||= '🤷‍♂️ no text'
    content_tag(:article, class: classes.join(' ')) do
      text.to_s.gsub("\n", "<br/>\n").html_safe
    end
  end

  def render_code_result(text, options={})
    render_prose("# Code result:<br/>\n#{text}", options)
  end

  def render_fancy_step_title(n, title)
    "<h3 class='text-3xl mb-4 font-bold' >[#️⃣#{n}] #{title}</h3>".html_safe
  end


end
