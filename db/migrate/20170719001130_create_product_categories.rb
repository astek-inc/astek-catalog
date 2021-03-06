class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
      t.datetime :deleted_at, index: true
    end
  end
end
