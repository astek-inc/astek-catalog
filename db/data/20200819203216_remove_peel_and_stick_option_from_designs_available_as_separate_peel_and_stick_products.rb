class RemovePeelAndStickOptionFromDesignsAvailableAsSeparatePeelAndStickProducts < ActiveRecord::Migration[5.2]
  def up

    peel_and_stick_wallpaper = Substrate.find_by(name: 'Neenah DigiScape Stick-R')
    design_skus = []
    Collection.find_by(name: 'Peel & Stick Wallpaper').designs.each do |d|
      main_sku = d.sku.gsub(/^PS/, '')
      design_skus << main_sku
      main_design = Design.find_by(sku: main_sku)
      if main_design.user_can_select_material
        main_design.delete_custom_material peel_and_stick_wallpaper
      end
    end
    puts design_skus
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
