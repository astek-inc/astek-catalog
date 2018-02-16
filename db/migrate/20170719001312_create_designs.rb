class CreateDesigns < ActiveRecord::Migration
  def change
    create_table :designs do |t|
      t.integer :collection_id
      t.string :name
      t.text :description
      t.text :keywords
      t.datetime :available_on
      t.datetime :expires_on
      t.timestamps null: false
    end

    add_foreign_key :designs, :collections
  end
end
