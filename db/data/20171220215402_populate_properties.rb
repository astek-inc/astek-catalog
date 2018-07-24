class PopulateProperties < ActiveRecord::Migration

  PROPERTIES = [
      { name: 'roll width', presentation: 'Roll width (inches)', klass_scope: 'Design' },
      { name: 'roll length', presentation: 'Roll length (yards)', klass_scope: 'Design' },
      { name: 'mural width', presentation: 'Mural width (inches)', klass_scope: 'Design' },
      { name: 'mural height', presentation: 'Mural height (inches)', klass_scope: 'Design' },
      { name: 'motif height', presentation: 'Motif height (inches)', klass_scope: 'Design' },
      { name: 'motif width', presentation: 'Motif width (inches)', klass_scope: 'Design' },
      { name: 'repeat match type', presentation: 'Repeat match type', klass_scope: 'Design' },
      { name: 'printed width', presentation: 'Printed width (inches)', klass_scope: 'Design' },
      { name: 'sale quantity', presentation: 'Sold in quantities of', klass_scope: 'Design' },
      { name: 'application', presentation: 'Application', klass_scope: 'Design' },
      { name: 'removability', presentation: 'Removability', klass_scope: 'Design' },
      { name: 'washability', presentation: 'Washability', klass_scope: 'Design' },
      { name: 'color fastness', presentation: 'Color fastness', klass_scope: 'Design' },
      { name: 'backing', presentation: 'Backing', klass_scope: 'Design' },
      { name: 'fire rating', presentation: 'Fire rating', klass_scope: 'Design' },
      { name: 'print type', presentation: 'Print type', klass_scope: 'Design' },
      { name: 'margin trim', presentation: 'Margin trim', klass_scope: 'Design' },
      { name: 'print to order', presentation: 'Print to order', klass_scope: 'Design' },
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
