class CreateDesignAliases < ActiveRecord::Migration[5.2]
  def change
    create_table :design_aliases do |t|
      t.integer :collection_id
      t.integer :design_id
      t.text :description
      t.integer :row_order, index: true
      t.timestamps
    end

    add_foreign_key :design_aliases, :collections
    add_foreign_key :design_aliases, :designs
  end
end
