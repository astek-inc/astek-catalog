class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :category_id
      t.string :name
      t.text :description
      t.text :keywords
      t.timestamps null: false
    end

    add_foreign_key :collections, :categories
  end
end
