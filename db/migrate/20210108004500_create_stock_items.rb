class CreateStockItems < ActiveRecord::Migration[5.2]
  def change

    create_table :stock_items do |t|
      t.integer :variant_id
      t.integer :substrate_id
      t.integer :backing_type_id

      t.string :price_code
      t.decimal :price, precision: 8, scale: 2
      t.decimal :sale_price, precision: 8, scale: 2
      t.boolean :display_sale_price, default: false
      t.integer :sale_unit_id
      t.integer :sale_quantity, default: 1
      t.integer :minimum_quantity, default: 1

      t.decimal :weight, precision: 8, scale: 2
      t.decimal :width, precision: 8, scale: 2
      t.decimal :height, precision: 8, scale: 2
      t.decimal :depth, precision: 8, scale: 2

      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end

    add_foreign_key :stock_items, :variants
    add_foreign_key :stock_items, :substrates
    add_foreign_key :stock_items, :backing_types
    add_foreign_key :stock_items, :sale_units

  end
end
