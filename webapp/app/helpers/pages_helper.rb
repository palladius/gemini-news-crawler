module PagesHelper


  def render_code_result(text, options={})
    render_prose("# Code result:<br/>\n#{text}", options)
  end

  def render_fancy_step_title(n, title)
    "<h3 class='text-3xl mb-4 font-bold' >[#️⃣#{n}] #{title}</h3>".html_safe
  end


end
