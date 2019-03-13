class UpdateFliepaperPricingAndSubstrates < ActiveRecord::Migration

  DATA_FILE = '2019-01-04_fliepaper_pricing_and_substrates.csv'
  DATA_DIR = 'data'

  require 'csv'

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|

      puts '- '*30

      item = OpenStruct.new row.to_h

      design = Design.find_by(sku: item.design_sku.strip)
      unless design.nil?
        puts design.name

        variant = Variant.find_by(sku: item.sku.strip)
        unless variant.nil?
          puts variant.name

          substrate = Substrate.find_by(name: item.substrate.strip)
          unless substrate.nil?


            price = BigDecimal(item.price.strip.gsub(/,/, ''), 2)
            puts price

            puts substrate.name

            design.price = price
            design.save!

            variant.substrate = substrate
            variant.save!

          end

        end
      end



      puts $\


    end

    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
