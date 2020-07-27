class UpdateNaturalLifeIvPricing < ActiveRecord::Migration[5.2]

  DATA_FILE = '2020-07-27_update_natural_life_iv_pricing.csv'
  DATA_DIR = 'data'

  require 'csv'

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new row.to_h
      if design = Design.find_by(sku: item.design_sku)
        design.update_attributes!(
          sale_unit: SaleUnit.find_by(name: item.sale_unit.strip),
          sale_quantity: item.sale_quantity.strip,
          minimum_quantity: item.minimum_quantity.strip,
          price: BigDecimal(item.price.strip.gsub(/,/, ''), 2),
        )
      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
