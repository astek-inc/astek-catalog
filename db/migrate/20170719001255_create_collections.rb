class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :product_type_id
      t.string :name
      t.text :description
      t.text :keywords
      t.timestamps null: false
    end

    add_foreign_key :collections, :product_types
  end
end
