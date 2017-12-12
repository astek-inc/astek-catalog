class CreateColorWays < ActiveRecord::Migration
  def change
    create_table :color_ways do |t|
      t.integer :design_id
      t.string :name
      t.text :sku, index: true
      t.string :slug, unique: true
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
