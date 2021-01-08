class AddPricingFieldsToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :price_code, :string
    add_column :variants, :price, :decimal, precision: 8, scale: 2
    add_column :variants, :sale_price, :decimal, precision: 5, scale: 2
    add_column :variants, :display_sale_price, :boolean, default: false
    add_column :variants,  :sale_unit_id, :integer
    add_column :variants, :sale_quantity, :integer, default: 1
    add_column :variants, :minimum_quantity, :integer, default: 1
  end
end
