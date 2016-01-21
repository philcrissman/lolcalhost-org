class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.string :image_url
      t.string :description
      t.string :feed_url
      t.string :root_url
      t.string :meta_title
      t.string :meta_description
      t.text :parsed_content
      t.text :raw_content

      t.timestamps null: false
    end
  end
end
