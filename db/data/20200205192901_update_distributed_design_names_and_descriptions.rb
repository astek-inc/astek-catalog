class UpdateDistributedDesignNamesAndDescriptions < ActiveRecord::Migration[5.2]

  DATA_DIR = 'data'

  DATA_FILES = %w[
    2020-02-05_update-design-names-and-descriptions_contemporary-textures.csv
    2020-02-05_update-design-names-and-descriptions_curious.csv
    2020-02-05_update-design-names-and-descriptions_decadent.csv
    2020-02-05_update-design-names-and-descriptions_dimensions.csv
    2020-02-05_update-design-names-and-descriptions_flash.csv
    2020-02-05_update-design-names-and-descriptions_loft.csv
    2020-02-05_update-design-names-and-descriptions_riviera-maison.csv
  ]

  require 'csv'
  # require 'pp'

  def up
    DATA_FILES.each do |filename|

      path = File.join(__dir__, DATA_DIR, filename)
      csv = CSV.read(path, headers: true)

      # puts filename

      csv.each do |row|
        item = OpenStruct.new(row.to_h)
        design = Design.find_by(sku: item.design_sku.strip)
        design.update_attribute('name', item.design_name.strip)
        design.descriptions.create!(description: item.description, websites: design.websites)

        design.variants.first.update_attribute('name', item.design_name.strip)

        # puts item
        # pp design
        # pp design.descriptions
        # pp design.variants

        # puts '= * - ~ '*10
      end

    end
    
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
