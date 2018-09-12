class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
