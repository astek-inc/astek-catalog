class PopulateVariantPricingDataFromDesigns < ActiveRecord::Migration[5.2]
  def up
    Design.all.each do |d|
      puts d.name
      d.variants.each do |v|
        puts v.name

        v.update(
          {
            price_code: d.price_code,
            price: d.price,
            sale_price: d.sale_price,
            display_sale_price: d.display_sale_price,
            sale_unit_id: d.sale_unit_id,
            sale_quantity: d.sale_quantity,
            minimum_quantity: d.minimum_quantity
          }
        )
      end

    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
