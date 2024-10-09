
module Langchain::Tool
  class ArticleTool

    extend Langchain::ToolDefinition
    include Langchain::DependencyHelper

    define_function :create, description: "Article DB Tool: Create a new article via ActiveRecord"
  end

end
