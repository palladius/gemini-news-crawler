require 'yaml'

class NewsFiler

  VERSION = 1  # Increment for future changes to the data format

  def initialize(output_dir)
    @output_dir = output_dir
    `mkdir -p "#{@output_dir}"`
  end

  def write_article(newspaper, article)
    filename = generate_unique_filename(newspaper: newspaper, article: article)
    filepath = File.join(@output_dir, filename)

    File.open(filepath, 'w') do |file|
      #file.write "# Dunno why but its not yamnl..\n"
      file.write "# [NewsFiler v#{VERSION}] NewsPaper: #{newspaper}\n"
      file.write "# [NewsFiler v#{VERSION}] GUID: #{article.entry_id}\n"
      #file.write to_yaml(article)
      file.write article.to_yaml
    end
  end

  def from_yaml(filename)
    filepath = File.join(@output_dir, filename)

    if File.exist?(filepath)
      data = YAML.safe_load(File.read(filepath))
      validate_version(data)  # Check for compatible version
      puts("TODO add Article info")
      @article_class.new(data.except(:version))  # Convert to Article object
    else
      raise ArgumentError, "File not found: #{filepath}"
    end
  end

  private

  def generate_unique_filename(newspaper:, article:)
    # newspaper is a string
    # article is a hash with some values.
    title = article.title
    published = article.published # class: Time
    guid = article.entry_id # .guid
    date = published.to_s[0,10]
    $stderr.puts(guid)
    #sanitized_title = title.to_s.parameterize(separator: '_')  # Replaces spaces with underscores
    sanitized_title = title.to_s.gsub("[^[:alnum:][:space:]]","")[0,64].gsub(/[ \/]/,'_')  # Replaces spaces with underscores
    "#{date}-#{sanitized_title}-v#{VERSION}.yaml"
  end

  def to_yaml(article)
    {
      version: VERSION,
      title: article.title,
      url: article.url,
      content: article.content,
      # Add other relevant fields from your article object here
    }

  end
end
