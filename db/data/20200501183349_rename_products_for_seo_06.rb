class RenameProductsForSeo06 < ActiveRecord::Migration[5.2]

  DATA_FILE = 'rename_products_for_seo_06.csv'
  DATA_DIR = 'data'

  require 'csv'
  # require 'pp'

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    master_type = VariantType.find_by(name: 'Master')

    csv.each do |row|

      # puts '- '*30

      item = OpenStruct.new row.to_h
      design = Design.find_by(sku: item.design_sku)
      variant = Variant.find_by(design: design, variant_type: master_type)

      unless design
        raise "Can't find design by sku "+item.design_sku
      end

      unless variant
        raise "Can't find master variant for "+design.name
      end

      design.update_attribute('name', item.design_name)
      variant.update_attribute('name', item.variant_name)

    end

    # raise 'Not ready yet'

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
