class CreateProductImports < ActiveRecord::Migration[5.2]
  def change
    create_table :product_imports do |t|
      t.string :name, null: false
      t.string :file, null: false
      t.boolean :imported, null: false, default: false
      t.timestamps
    end
  end
end
