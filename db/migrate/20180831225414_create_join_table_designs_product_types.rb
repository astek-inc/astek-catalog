class CreateJoinTableDesignsProductTypes < ActiveRecord::Migration
  def change
    create_join_table :designs, :product_types do |t|
      t.index [:design_id, :product_type_id]
      t.index [:product_type_id, :design_id]
    end
  end
end
