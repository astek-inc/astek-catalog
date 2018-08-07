class CreateSaleUnits < ActiveRecord::Migration
  def change
    create_table :sale_units do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
