class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.string :name
      t.text :description
      t.integer :product_category_id
      t.timestamps null: false
      t.datetime :deleted_at, index: true
    end
    add_foreign_key :product_types, :product_categories
  end
end
