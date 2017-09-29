class CreateDesigns < ActiveRecord::Migration
  def change
    create_table :designs do |t|
      t.integer :collection_id
      t.string :name
      t.text :description
      t.text :keywords
      t.timestamps null: false
    end
  end
end
