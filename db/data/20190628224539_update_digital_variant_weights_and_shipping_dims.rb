class UpdateDigitalVariantWeightsAndShippingDims < ActiveRecord::Migration[5.2]

  DATA_DIR = 'data'
  DATA_FILE = 'digital_variant_weights_and_shipping_dims_licensors.csv'

  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new(row.to_h)

      # puts item

      if variant = Variant.find_by(sku: item.sku.strip)
        variant.update_attributes!(
            {
                weight: BigDecimal(item.weight, 2),
                width: BigDecimal(item.package_width, 2),
                height: BigDecimal(item.package_height, 2),
                depth: BigDecimal(item.package_depth, 2)
            }
        )
      end
    end

    # raise
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
