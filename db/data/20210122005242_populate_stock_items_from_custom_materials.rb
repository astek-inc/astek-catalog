class PopulateStockItemsFromCustomMaterials < ActiveRecord::Migration[5.2]
  def up
    Design.where(user_can_select_material: true).each_with_index do |d, i|
      # puts i
      puts d.sku
      puts d.name

      puts 'Variants:'
      d.variants.each do |v|
        puts v.sku

        puts 'Stock Items:'
        v.stock_items.each do |s|
          puts "\t"+s.substrate_or_backing

          puts 'Create Stock Items:'
          d.custom_materials.each do |c|



            puts "\t#{c.substrate.name} :: #{s.substrate.name}"
            if s.substrate == c.substrate
              puts "\t--Skip this one"
            end

            puts "\tPrice: #{(BigDecimal(s.price, 0) + BigDecimal(c.surcharge, 0))}"
            puts "\tWeight: #{c.substrate.weight_per_square_foot}"

            # {
            #   price: (BigDecimal(s.price, 0) + BigDecimal(c.surcharge, 0)),
            #   sale_unit_id: s.sale_unit_id,
            #   sale_quantity: s.sale_quantity,
            #   minimum_quantity: s.minimum_quantity,
            #   weight: c.substrate.weight_per_square_foot,
            #   width: s.width,
            #   height: s.height,
            #   depth: s.depth
            # }

          end
        end



      end

      puts '- '*10
    end

    raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
