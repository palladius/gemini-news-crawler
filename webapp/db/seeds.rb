# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if ENV['DESTROY_ALL_BEFORE'] == 'YES_WHY_NOT'
  puts("DESTROY_ALL_BEFORE activated")
  Article.delete_all
  Category.delete_all
else
  puts('to DESTROY_ALL_BEFORE please activate the Omega13')
end

Dir[File.dirname(__FILE__) + '/seeds.d/*.rb'].each {|file| require file }
