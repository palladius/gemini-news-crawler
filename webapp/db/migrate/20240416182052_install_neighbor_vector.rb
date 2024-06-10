# frozen_string_literal: true

class InstallNeighborVector < ActiveRecord::Migration[7.1]
  # From neighbor: https://github.com/ankane/neighbor
  def change
    enable_extension 'vector'

    add_column :articles, :article_embedding, :vector, limit: 768 # dimensions
  end
end
