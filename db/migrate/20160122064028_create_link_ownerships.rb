class CreateLinkOwnerships < ActiveRecord::Migration
  def change
    create_table :link_ownerships do |t|
      t.integer :person_id
      t.integer :link_id

      t.timestamps null: false
    end
  end
end
