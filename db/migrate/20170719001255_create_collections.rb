class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :product_category_id
      t.string :name
      t.text :description
      t.integer :vendor_id
      t.text :keywords
      t.boolean :suppress_from_display, default: :false, null: false, index: true
      t.boolean :user_can_select_material, default: :false, null: false
      t.timestamps null: false
    end

    add_foreign_key :collections, :product_categories
    add_foreign_key :collections, :vendors
  end
end
