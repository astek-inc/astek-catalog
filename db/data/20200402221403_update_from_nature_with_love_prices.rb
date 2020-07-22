class UpdateFromNatureWithLovePrices < ActiveRecord::Migration[5.2]

  DATA_FILE = '2020-04-02_update_from_nature_with_love_prices.csv'
  DATA_DIR = 'data'

  require 'csv'
  # require 'pp'

  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)
    csv.each do |row|

      # puts '- '*30

      item = OpenStruct.new row.to_h
      design = Design.find_by(sku: item.design_sku)

      unless design
        raise "Can't find design by sku "+item.design_sku
      end

      # pp item
      # pp design

      # puts design.price

      price = BigDecimal(item.price.strip.gsub(/,/, ''), 2)
      # puts price

      design.update_attribute('price', price)

    end

    # raise 'Not ready yet'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
