class PopulateProperties < ActiveRecord::Migration

  PROPERTIES = [
      # { name: 'color', presentation: 'Color', klass_scope: 'Variant' },
      { name: 'roll width', presentation: 'Roll width', klass_scope: 'Design' },
      { name: 'roll length', presentation: 'Roll length', klass_scope: 'Design' },
      { name: 'repeat width', presentation: 'Repeat Width', klass_scope: 'Design' },
      { name: 'repeat length', presentation: 'Repeat Length', klass_scope: 'Design' },
      { name: 'mural width', presentation: 'Mural width', klass_scope: 'Design' },
      { name: 'mural height', presentation: 'Mural height', klass_scope: 'Design' },
  ]

  # require 'pp'
  def self.up
    PROPERTIES.each do |p|
      # pp p
      Property.create!(p)
    end
  end

  def self.down
    PROPERTIES.each do |p|
      Property.find_by(name: p[:name]).destroy!
    end
    # raise ActiveRecord::IrreversibleMigration
  end

end
