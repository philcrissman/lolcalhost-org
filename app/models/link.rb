class Link < ActiveRecord::Base
  acts_as_taggable

  has_many :link_ownerships, inverse_of: :link
  has_many :people, :through => :link_ownerships

  validates :url, :uniqueness => true

  accepts_nested_attributes_for :link_ownerships

  def date_string
    created_at.strftime("%e %b %Y")
  end

  def found_title(person)
    [title(person), meta_title, url].select{|t| t unless t.blank?}.first
  end

  def found_description(person)
    [description(person), meta_description].select{|t| t unless t.blank?}.first
  end

  def title(person)
    if person
      person_link_ownership(person).title
    else
      ''
    end
  end

  def description(person)
    if person
      person_link_ownership(person).description
    else
      ''
    end
  end

  def person_link_ownership(person)
    link_ownerships.reload.where(person_id: person.id).first
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
