class CreateSubstrates < ActiveRecord::Migration
  def change
    create_table :substrates do |t|
      t.string :name
      t.text :description
      t.text :keywords
      t.integer :backing_type_id
      t.integer :row_order, index: true
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end

    add_foreign_key :substrates, :backing_types
  end
end
