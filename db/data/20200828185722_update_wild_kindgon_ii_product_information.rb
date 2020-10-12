class UpdateWildKindgonIiProductInformation < ActiveRecord::Migration[5.2]

  DATA_DIR = 'data'
  DATA_FILE = '2020-08-28_product_data_update_wild_kindom_ii.csv'

  require 'csv'

  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new row.to_h
      if design = Design.find_by(sku: item.design_sku)

        puts design.name
        %w[repeat_match_type application hanging_instructions].each do |p|
          if val = item.send(p)
            design.set_property p, val
          end
        end

      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
