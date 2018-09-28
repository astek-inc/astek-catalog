class PopulateProperties < ActiveRecord::Migration

  PROPERTIES = [
      { name: 'roll_width', presentation: 'Roll width (inches)' },
      { name: 'roll_length', presentation: 'Roll length (yards)' },
      { name: 'mural_width', presentation: 'Mural width (inches)' },
      { name: 'mural_height', presentation: 'Mural height (inches)' },
      { name: 'motif_height', presentation: 'Motif height (inches)' },
      { name: 'motif_width', presentation: 'Motif width (inches)' },
      { name: 'repeat_match_type', presentation: 'Repeat match type' },
      { name: 'printed_width', presentation: 'Printed width (inches)' },
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
