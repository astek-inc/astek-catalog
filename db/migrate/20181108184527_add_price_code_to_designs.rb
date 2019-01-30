class AddPriceCodeToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :price_code, :string
  end
end
