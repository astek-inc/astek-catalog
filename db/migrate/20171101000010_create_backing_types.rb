class CreateBackingTypes < ActiveRecord::Migration
  def change
    create_table :backing_types do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
