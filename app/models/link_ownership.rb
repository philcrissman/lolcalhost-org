class LinkOwnership < ActiveRecord::Base
  acts_as_taggable

  belongs_to :link
  belongs_to :person
end
