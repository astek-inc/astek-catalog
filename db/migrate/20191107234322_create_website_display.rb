class CreateWebsiteDisplay < ActiveRecord::Migration[5.2]
  def change
    create_table :website_display do |t|
      t.integer :websiteable_id, index: true
      t.string :websiteable_type
      t.integer :website_id, index: true
      t.timestamps
    end
  end
end
