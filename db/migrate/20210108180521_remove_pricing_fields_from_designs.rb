class RemovePricingFieldsFromDesigns < ActiveRecord::Migration[5.2]
  def change
    remove_column :designs, :price_code, :string
    remove_column :designs, :price, :decimal, precision: 8, scale: 2
    remove_column :designs, :sale_price, :decimal, precision: 5, scale: 2
    remove_column :designs, :display_sale_price, :boolean, default: false
    remove_column :designs,  :sale_unit_id, :integer
    remove_column :designs, :sale_quantity, :integer, default: 1
    remove_column :designs, :minimum_quantity, :integer, default: 1
  end
end
