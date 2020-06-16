class CreateVariantSubstrates < ActiveRecord::Migration[5.2]
  def change
    create_table :variant_substrates do |t|
      t.integer :variant_id
      t.integer :substrate_id
      t.timestamps null: false
      t.index [:variant_id, :substrate_id]
      t.index [:substrate_id, :variant_id]
    end
  end
end
