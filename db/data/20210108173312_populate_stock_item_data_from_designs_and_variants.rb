class PopulateStockItemDataFromDesignsAndVariants < ActiveRecord::Migration[5.2]
  def up
    Design.all.each do |d|
      puts d.name
      d.variants.each do |v|
        puts v.name

        if d.digital?
          v.variant_substrates.each do |vs|

            StockItem.create!(
              {
                variant_id: v.id,
                substrate_id: vs.substrate_id,

                price_code: d.price_code,
                price: d.price,
                sale_price: d.sale_price,
                display_sale_price: d.display_sale_price,
                sale_unit_id: d.sale_unit_id,
                sale_quantity: d.sale_quantity,
                minimum_quantity: d.minimum_quantity,

                weight: v.weight,
                width: v.width,
                height: v.height,
                depth: v.depth,

                websites: vs.websites

              }
            )

          end
        else

          StockItem.create!(
            {
              variant_id: v.id,
              backing_type_id: v.backing_type_id,
              price_code: d.price_code,
              price: d.price,
              sale_price: d.sale_price,
              display_sale_price: d.display_sale_price,
              sale_unit_id: d.sale_unit_id,
              sale_quantity: d.sale_quantity,
              minimum_quantity: d.minimum_quantity,

              weight: v.weight,
              width: v.width,
              height: v.height,
              depth: v.depth,

              websites: v.websites

            }
          )

        end
      end

    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
