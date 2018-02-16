class CreateVariantTypes < ActiveRecord::Migration
  def change
    create_table :variant_types do |t|
      t.string :name
      t.timestamps null: false
      t.timestamp :deleted_at, index: true
    end
  end
end
