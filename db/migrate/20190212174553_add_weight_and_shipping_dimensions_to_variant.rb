class AddWeightAndShippingDimensionsToVariant < ActiveRecord::Migration
  def change
    add_column :variants, :weight, :decimal, precision: 5, scale: 2
    add_column :variants, :width, :decimal, precision: 5, scale: 2
    add_column :variants, :height, :decimal, precision: 5, scale: 2
    add_column :variants, :depth, :decimal, precision: 5, scale: 2
  end
end
