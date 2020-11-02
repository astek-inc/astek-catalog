class AddPrintedNaturalsInstallImages < ActiveRecord::Migration[5.2]
  DATA_DIR = 'data'
  DATA_FILE = '2020-11-02_add_printed_naturals_install_images.csv'

  require 'csv'

  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new row.to_h
      if design = Design.find_by(sku: item.design_sku)

        variant = design.variants.first
        websites = variant.websites

        VariantInstallImage.create!(
            {
                remote_file_url: item.install_images,
                type: 'VariantInstallImage',
                owner_id: variant.id,
                websites: websites
            }
        )

      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
