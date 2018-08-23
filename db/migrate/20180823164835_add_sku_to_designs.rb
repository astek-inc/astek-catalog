class AddSkuToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :sku, :string
    add_index :designs, :sku
  end
end
