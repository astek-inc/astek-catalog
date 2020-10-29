class AddNamesAndDescriptionsToMetallicWorldIiDesigns < ActiveRecord::Migration[5.2]

  DATA_DIR = 'data'
  DATA_FILE = '2020-10-29_product_data_update_metallic_world_ii.csv'

  require 'csv'

  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new row.to_h
      if design = Design.find_by(sku: item.design_sku)

        puts design.name
        design.update_attribute('name', item.design_name)
        design.variants.first.update_attribute('name', item.variant_name)
        Description.create!(
            {
                descriptionable_type: 'Design',
                descriptionable_id: design.id,
                description: item.description,
                websites: design.websites
            }
        )
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
