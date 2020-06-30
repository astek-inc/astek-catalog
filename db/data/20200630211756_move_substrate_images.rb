class MoveSubstrateImages < ActiveRecord::Migration[5.2]
  def up
    Substrate.all.each do |s|

      puts s.name

      count = s.substrate_images.count

      if count == 1

        i = s.substrate_images.first
        url = i.file.url #.gsub('astek-catalog-dev', 'astek-catalog-production')
        SubstrateTextureImage.create!(
            {
                remote_file_url: url,
                type: 'SubstrateTextureImage',
                owner_id: s.id
            }
        )

      elsif count == 2

        i = s.substrate_images.first
        url = i.file.url #.gsub('astek-catalog-dev', 'astek-catalog-production')
        SubstratePrintImage.create!(
            {
                remote_file_url: url,
                type: 'SubstratePrintImage',
                owner_id: s.id
            }
        )

        i = s.substrate_images.last
        url = i.file.url #.gsub('astek-catalog-dev', 'astek-catalog-production')
        SubstrateTextureImage.create!(
            {
                remote_file_url: url,
                type: 'SubstrateTextureImage',
                owner_id: s.id
            }
        )

      end

    end

    # raise 'Data migration not ready yet'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
