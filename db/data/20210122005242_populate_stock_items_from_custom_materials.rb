class PopulateStockItemsFromCustomMaterials < ActiveRecord::Migration[5.2]
  def up
    Design.where(user_can_select_material: true).each_with_index do |design, i|

      # puts '- + - ' * 20
      puts "Design: #{design.name} - #{design.sku}"

      # puts 'Variants:'
      design.variants.for_domain('astekhome.com').each do |variant|
        # puts "#{variant.name} - #{variant.sku}"

        # puts 'Stock Items:'
        variant.stock_items.for_domain('astekhome.com').each do |stock_item|

          # puts 'Create Stock Items:'
          design.custom_materials.each do |custom_material|

            # puts '---'
            # puts "\t#{custom_material.substrate.name}"

            #   puts "\t--This stock item already exists. Set its row order position to first"
            if stock_item.substrate == custom_material.substrate
              stock_item.update row_order_position: :first
              next
            end

            # puts "\tPrice: #{(BigDecimal(stock_item.price, 0) + BigDecimal(custom_material.surcharge, 0))}"
            # puts "\tWeight: #{custom_material.substrate.weight_per_square_foot}"

            new_stock_item = StockItem.create!({
              variant_id: variant.id,
              substrate_id: custom_material.substrate.id,
              price: (BigDecimal(stock_item.price, 0) + BigDecimal(custom_material.surcharge, 0)),
              sale_unit_id: stock_item.sale_unit_id,
              sale_quantity: stock_item.sale_quantity,
              minimum_quantity: stock_item.minimum_quantity,
              weight: custom_material.substrate.weight_per_square_foot,
              width: stock_item.width,
              height: stock_item.height,
              depth: stock_item.depth
            })

            new_stock_item.websites = stock_item.websites

          end
        end



      end

      # puts '- '*10
    end

    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
