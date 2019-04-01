class WindsOfTheAsianPacificPriceUpdate < ActiveRecord::Migration

  DATA_DIR = 'data'
  DATA_FILE = '2019-03-18_winds_of_the_asian_pacific_price_update.csv'

  require 'csv'

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new(row.to_h)
      design = Design.find_by(sku: item.sku.strip)
      design.update_attributes!(
          price_code: item.price_code.strip,
          price: BigDecimal(item.price.strip.gsub(/,/, ''), 2)
      )
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
