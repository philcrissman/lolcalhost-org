class AddTitleDescriptionToLinkOwnership < ActiveRecord::Migration
  def change
    add_column :link_ownerships, :title, :string
    add_column :link_ownerships, :description, :text
    remove_columns :links, :title, :description
  end
end
