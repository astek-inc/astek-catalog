class UpdateDigitalLibrarySubstrates < ActiveRecord::Migration

  DATA_FILE = '2019-01-04_digital_library_substrates.csv'
  DATA_DIR = 'data'

  require 'csv'

  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|

      puts '- '*30

      item = OpenStruct.new row.to_h

      puts item.sku

      if variant = Variant.find_by(sku: item.sku)

        substrate = Substrate.find_by(name: item.substrate)
        puts variant.name
        puts substrate.name

        variant.substrate = substrate
        variant.save!

      end

      puts $\


    end

    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
