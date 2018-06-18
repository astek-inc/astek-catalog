class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.integer :design_id
      t.integer :variant_type_id
      t.string :name
      t.text :sku, index: true
      t.text :price_code
      t.string :slug, unique: true
      t.integer :row_order, index: true
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end

    add_foreign_key :variants, :designs
    add_foreign_key :variants, :variant_types
  end
end
