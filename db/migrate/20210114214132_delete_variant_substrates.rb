class DeleteVariantSubstrates < ActiveRecord::Migration[5.2]
  def change
    VariantSubstrate.destroy_all
    drop_table :variant_substrates
  end
end
