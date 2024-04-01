module CategoriesHelper

  def render_fancy_category(category)
    link_to "#{Category.emoji}#{category.cleaned_up}", category
  end

end
