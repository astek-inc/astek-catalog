class CreateDesignProperties < ActiveRecord::Migration
  def change
    create_table :design_properties do |t|
      t.integer :design_id
      t.integer :property_id
      t.string :value
      t.integer :row_order, index: true
      t.timestamps null: false
      t.index [:design_id, :property_id]
      t.index [:property_id, :design_id]
    end
  end
end
