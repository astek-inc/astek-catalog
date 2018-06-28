class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.string :name
      t.text :description
      t.text :keywords
      t.timestamps null: false
    end
  end
end
