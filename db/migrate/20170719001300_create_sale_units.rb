class CreateSaleUnits < ActiveRecord::Migration
  def change
    create_table :sale_units do |t|
      t.string :name
      t.text :description
      t.string :slug, unique: true
      t.integer :row_order, index: true
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
