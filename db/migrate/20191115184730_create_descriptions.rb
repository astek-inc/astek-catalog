class CreateDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :descriptions do |t|
      t.string :descriptionable_type, index: true
      t.integer :descriptionable_id, index: true
      t.text :description
      t.timestamps
    end
  end
end
