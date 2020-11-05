class AddSalePriceToDesigns < ActiveRecord::Migration[5.2]
  def change
    add_column :designs, :sale_price, :decimal, precision: 5, scale: 2
    add_column :designs, :display_sale_price, :boolean, default: false
  end
end
