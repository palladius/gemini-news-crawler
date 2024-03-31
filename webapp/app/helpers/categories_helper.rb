module CategoriesHelper

  def render_fancy_category(category)
    link_to "#{Category.emoji}#{category}", category
  end

end
