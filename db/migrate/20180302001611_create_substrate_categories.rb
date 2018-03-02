class CreateSubstrateCategories < ActiveRecord::Migration
  def change
    create_table :substrate_categories do |t|
      t.string :name
      t.text :description
      t.text :keywords
      t.string :slug, unique: true
      t.integer :row_order, index: true
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
