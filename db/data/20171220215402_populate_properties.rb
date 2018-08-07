class PopulateProperties < ActiveRecord::Migration

  PROPERTIES = [
      { name: 'roll_width', presentation: 'Roll width (inches)', klass_scope: 'Design' },
      { name: 'roll_length', presentation: 'Roll length (yards)', klass_scope: 'Design' },
      { name: 'mural_width', presentation: 'Mural width (inches)', klass_scope: 'Design' },
      { name: 'mural_height', presentation: 'Mural height (inches)', klass_scope: 'Design' },
      { name: 'motif_height', presentation: 'Motif height (inches)', klass_scope: 'Design' },
      { name: 'motif_width', presentation: 'Motif width (inches)', klass_scope: 'Design' },
      { name: 'repeat_match_type', presentation: 'Repeat match type', klass_scope: 'Design' },
      { name: 'printed_width', presentation: 'Printed width (inches)', klass_scope: 'Design' },
      { name: 'sale_quantity', presentation: 'Sold in quantities of', klass_scope: 'Design' },
      { name: 'application', presentation: 'Application', klass_scope: 'Design' },
      { name: 'removability', presentation: 'Removability', klass_scope: 'Design' },
      { name: 'washability', presentation: 'Washability', klass_scope: 'Design' },
      { name: 'color_fastness', presentation: 'Color fastness', klass_scope: 'Design' },
      { name: 'backing', presentation: 'Backing', klass_scope: 'Design' },
      { name: 'fire_rating', presentation: 'Fire rating', klass_scope: 'Design' },
      { name: 'print_type', presentation: 'Print type', klass_scope: 'Design' },
      { name: 'margin_trim', presentation: 'Margin trim', klass_scope: 'Design' },
      { name: 'print_to_order', presentation: 'Print to order', klass_scope: 'Design' },
      { name: 'minimum_quantity', presentation: 'Minimum quantity', klass_scope: 'Design' }
  ]

  # require 'pp'
  def self.up
    PROPERTIES.each do |p|
      # pp p
      Property.create!(p)
    end
  end

  def self.down
    Property.destroy_all
  end

end
