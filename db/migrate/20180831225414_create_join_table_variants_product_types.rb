class CreateJoinTableVariantsProductTypes < ActiveRecord::Migration
  def change
    create_join_table :variants, :product_types do |t|
      t.index [:variant_id, :product_type_id]
      t.index [:product_type_id, :variant_id]
    end
  end
end
