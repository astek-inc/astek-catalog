class UpdateBrewsterRollLengths < ActiveRecord::Migration[5.2]

  DATA_FILE = 'update_brewster_roll_lengths.csv'
  DATA_DIR = 'data'

  require 'csv'
  # require 'pp'

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    property = Property.find_by(name: 'roll_length_feet')

    csv.each do |row|

      item = OpenStruct.new row.to_h
      if design = Design.find_by(sku: item.design_sku)
        # pp design
        design.design_properties << DesignProperty.create(design: design, property: property, value: item.roll_length_feet)
      end

    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
