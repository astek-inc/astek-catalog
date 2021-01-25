class PopulateStockItemsFromCustomMaterials < ActiveRecord::Migration[5.2]
  def up
    Design.where(user_can_select_material: true).each_with_index do |d, i|
      puts i
      puts d.sku
      puts d.name

      d.variants.each do |v|

      end

      puts '- '*10
    end

    raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
