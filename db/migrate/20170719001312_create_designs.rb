class CreateDesigns < ActiveRecord::Migration
  def change
    create_table :designs do |t|
      t.integer :collection_id
      t.integer :product_type_id
      t.string :name
      t.text :description
      t.text :keywords
      t.decimal :price, precision: 8, scale: 2
      t.integer :sale_unit_id
      t.decimal :weight, precision: 5, scale: 2
      t.datetime :available_on
      t.datetime :expires_on
      t.timestamps null: false
    end

    add_foreign_key :designs, :collections
    add_foreign_key :designs, :product_types
    add_foreign_key :designs, :sale_units
  end
end
