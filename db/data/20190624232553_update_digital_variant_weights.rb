class UpdateDigitalVariantWeights < ActiveRecord::Migration[5.2]

  DATA_DIR = 'data'
  DATA_FILES = %w[
    digital_variant_weights_general.csv
    digital_variant_weights_digital_library.csv
    digital_variant_weights_panoramic_images.csv
  ]

  def up

    DATA_FILES.each do |file|
      path = File.join(__dir__, DATA_DIR, file)
      csv = CSV.read(path, headers: true)

      csv.each do |row|
        item = OpenStruct.new(row.to_h)
        if variant = Variant.find_by(sku: item.sku.strip)
          variant.update_attribute('weight', BigDecimal(item.weight, 2))
        end
      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
