class CreateProductTypeGroups < ActiveRecord::Migration
  def change
    create_table :product_type_groups do |t|
      t.string :name
      t.text :description
      t.integer :row_order, index: true
      t.timestamps null: false
      t.datetime :deleted_at, index: true
    end
  end
end
