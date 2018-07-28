class PopulateSubstrates < ActiveRecord::Migration

  DATA_DIR = 'data'
  DATA_FILE = 'substrates.csv'

  require 'csv'
  require 'pp'

  def up

    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|

      item = OpenStruct.new(row.to_h)

      substrate = Substrate.create!({
          name: item.name,
          description: item.description,
          keywords: item.keywords,
          backing_type: (item.backing_type ? BackingType.find_or_create_by!(name: item.backing_type) : nil)
      })

      unless item.categories.nil?
        substrate.substrate_categories << SubstrateCategory.where(name: item.categories.split(',').map(&:strip))
      end

      unless item.images.nil?
        item.images.split(',').map(&:strip).each do |image_url|
          SubstrateImage.create!({
            remote_file_url: image_url,
            type: 'SubstrateImage',
            owner_id: substrate.id
          })
        end
      end



    end

  end

  def down
    Substrate.destroy_all
    # raise ActiveRecord::IrreversibleMigration
  end
end
