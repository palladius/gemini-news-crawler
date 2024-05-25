module CategoriesHelper

  def render_fancy_category(category)
#    link_to("#{Category.emoji} #{category.cleaned_up}", category, class: "font-mono text-xs mr-2 underline-gradient") # Add classes directly
    link_to("#{Category.emoji} #{category.cleaned_up}", category, class: "font-mono text-xs mr-2 underline-gradient text-decoration-blue")  # Add text-decoration-blue

  end

end
