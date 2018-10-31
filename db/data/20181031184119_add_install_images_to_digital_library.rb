class AddInstallImagesToDigitalLibrary < ActiveRecord::Migration

  DATA_DIR = 'data'
  DATA_FILE = 'Digital_Library_Installs.csv'

  require 'csv'
  # require 'pp'

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|

      item = OpenStruct.new(row.to_h)

      unless item.image_url.nil?

        variant = Variant.find_by(sku: item.sku)
        unless variant.nil?
          puts "Creating install image for #{item.sku}: #{item.image_url}"
          VariantInstallImage.create!({
              remote_file_url: item.image_url,
              type: 'VariantInstallImage',
              owner_id: variant.id
          })
        end

      end

    end

    # raise

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
