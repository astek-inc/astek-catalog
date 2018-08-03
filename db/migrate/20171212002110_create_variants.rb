class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.integer :design_id
      t.integer :variant_type_id
      t.string :name
      t.text :sku, index: true
      t.string :slug, unique: true
      t.integer :substrate_id
      t.integer :row_order, index: true
      t.string :tearsheet
      t.boolean :suppress_from_searches, default: :false, null: false
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end

    add_foreign_key :variants, :designs
    add_foreign_key :variants, :variant_types
    add_foreign_key :variants, :substrates
  end
end
