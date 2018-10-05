class PopulateProperties < ActiveRecord::Migration

  PROPERTIES = [
      { name: 'roll_width_inches', presentation: 'Roll width' },
      { name: 'roll_length_yards', presentation: 'Roll length' },
      { name: 'roll_length_meters', presentation: 'Roll length' },
      { name: 'mural_width_inches', presentation: 'Mural width' },
      { name: 'mural_height_inches', presentation: 'Mural height' },
      { name: 'tile_width_inches', presentation: 'Tile width' },
      { name: 'tile_height_inches', presentation: 'Tile height' },
      { name: 'motif_height_inches', presentation: 'Motif height' },
      { name: 'motif_width_inches', presentation: 'Motif width' },
      { name: 'repeat_match_type', presentation: 'Repeat match type' },
      { name: 'printed_width_inches', presentation: 'Printed width' },
      { name: 'application', presentation: 'Application' },
      { name: 'removability', presentation: 'Removability' },
      { name: 'washability', presentation: 'Washability' },
      { name: 'color_fastness', presentation: 'Color fastness' },
      { name: 'fire_rating', presentation: 'Fire rating' },
      { name: 'print_type', presentation: 'Print type' },
      { name: 'margin_trim', presentation: 'Margin trim' },
      { name: 'print_to_order', presentation: 'Print to order' },
  ]

  def self.up
    PROPERTIES.each do |p|
      Property.create!(p)
    end
  end

  def self.down
    Property.destroy_all
  end

end
