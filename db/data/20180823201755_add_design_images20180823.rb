class AddDesignImages20180823 < ActiveRecord::Migration

  DATA_DIR = 'data'
  DATA_FILE = 'design_images_2018-08-23.csv'

  require 'csv'
  # require 'pp'

  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new(row.to_h)
      design = Design.find_by!(sku: item.design_sku)
      if item.design_images
        item.design_images.split(',').map { |i| i.strip }.each do |url|
          puts url
          DesignImage.create!({
                                  remote_file_url: url,
                                  type: 'DesignImage',
                                  owner_id: design.id
                              })
        end
      end

      puts design.collection.name + ' - ' + design.name + ' '+ design.id.to_s

    end

    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
