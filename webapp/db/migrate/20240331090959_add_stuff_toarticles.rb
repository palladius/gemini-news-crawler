class AddStuffToarticles < ActiveRecord::Migration[7.1]
  def change
    # newspaper:string macro_region:string
    add_column :articles, :newspaper, :string
    add_column :articles, :macro_region, :string
  end
end
