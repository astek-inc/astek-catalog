class UpdateCollectionLavish < ActiveRecord::Migration

  DATA_FILE = '2018-12-14_lavish_update.csv'

  DESIGN_FIELDS = %w[price sale_quantity minimum_quantity weight]
  DESIGN_PROPERTY_FIELDS = %w[roll_width_inches roll_length_yards mural_width_inches mural_height_inches tile_width_inches tile_height_inches motif_width_inches motif_height_inches repeat_match_type printed_width_inches]

  DATA_DIR = 'data'

  require 'csv'

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|

      item = OpenStruct.new row.to_h

      item.sale_unit = SaleUnit.find_by(name: item.sale_unit.strip)
      if item.sale_unit.nil?
        raise 'Missing sale unit'
      end

      item.price = BigDecimal(item.price.strip.gsub(/,/, ''), 2)
      if item.price.nil?
        raise 'Missing price'
      end

      if item.sale_quantity.nil?
        raise 'Missing sale quantity'
      end

      if item.minimum_quantity.nil?
        raise 'Missing minimum quantity'
      end

      item.weight = BigDecimal(item.weight.strip.gsub(/,/, ''), 2)
      if item.weight.nil?
        raise 'Missing weight'
      end

      design = Design.find_by(sku: item.design_sku)
      puts "Updating #{design.name}"

      design.sale_unit = item.sale_unit
      design.update_attributes!(
          {
              sale_unit: item.sale_unit,
              price: item.price,
              sale_quantity: item.sale_quantity,
              minimum_quantity: item.minimum_quantity,
              weight: item.weight
          }
      )

      puts "Updating #{design.name} properties"
      DESIGN_PROPERTY_FIELDS.each do |field|
        if value = item.send(field)
          design.set_property field, value
        else
          design.delete_property field
        end
      end

      puts '- '*30
      puts $\

    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
