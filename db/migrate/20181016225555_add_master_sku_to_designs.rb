class AddMasterSkuToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :master_sku, :string
    add_index :designs, :master_sku
  end
end
