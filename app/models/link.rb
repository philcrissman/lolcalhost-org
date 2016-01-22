class Link < ActiveRecord::Base
  acts_as_taggable

  def date_string
    created_at.strftime("%e %b %Y")
  end

  def found_title
    title || meta_title
  end

  def refresh_metadata
    image_url = fetch_image_url
    meta_inspect = MetaInspector.new(url)

    self.image_url = image_url
    self.feed_url = metadata.feed
    self.root_url = meta_inspect.root_url
    self.meta_title = metadata.title
    self.meta_description = if metadata.description.nil?
      meta_inspect.description
    else
      metadata.description
    end
    self.parsed_content = metadata.body
    self.raw_content = metadata.html_body

    # Use lede as description if no description was supplied
    if description.blank?
      self.description = metadata.lede
    end

    add_tags metadata

    # TODO add some fields to a new migration
    # self.lede = metadata.lede
    # self.author = metadata.author
    # self.favicon = metadata.favicon
    # self.summary = [some_summarization_gem?]
  end

  def fetch_image_url
    link_thumbnailer.images.empty? ? "" : link_thumbnailer.images.first.src.to_s
  end

  def add_tags metadata
    keywords = metadata.keywords.map{|tuple| tuple.first}
    self.tag_list.add(keywords)
  end

  def metadata
    @metadata ||= Pismo[url]
  end

  def link_thumbnailer
    @link_thumbnailer ||= LinkThumbnailer.generate(url)
  end
end
