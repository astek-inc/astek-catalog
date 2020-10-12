class PeelAndStickWallpaperDescriptionUpdate < ActiveRecord::Migration[5.2]

  DATA_FILE = '2020-08-21_peel_and_stick_wallpaper_description_update.csv'
  DATA_DIR = 'data'

  require 'csv'

  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|
      item = OpenStruct.new row.to_h
      if design = Design.find_by(sku: item.design_sku)
        design.descriptions.first.update_attribute('description', item.description)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
