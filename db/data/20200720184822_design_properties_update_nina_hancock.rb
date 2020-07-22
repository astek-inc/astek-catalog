class DesignPropertiesUpdateNinaHancock < ActiveRecord::Migration[5.2]

  DATA_FILE = '2020-07-20_design_properties_update_nina_hancock.csv'
  DATA_DIR = 'data'

  require 'csv'

  PROPERTIES = %w[
    roll_width_inches
    roll_length_yards
    vertical_repeat_inches
    repeat_match_type
  ]

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new row.to_h
      if design = Design.find_by(sku: item.design_sku)
        PROPERTIES.each do |p|
          design.set_property(p, item.send(p))
        end
      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
