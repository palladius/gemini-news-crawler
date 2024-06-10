# frozen_string_literal: true

# Adds PgVector extension. See
# https://stackoverflow.com/questions/16611226/how-to-install-postgres-extensions-at-database-creation

class AddPgVectorExtension < ActiveRecord::Migration[7.1]
  def change
    # "CREATE EXTENSION vector;"
    enable_extension 'vector'
    # Or: same thing:
    # execute <<-SQL
    #     CREATE EXTENSION IF NOT EXISTS vector;
    # SQL
  end
end
