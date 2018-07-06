class PopulateProperties < ActiveRecord::Migration

  PROPERTIES = [
      { name: 'roll width', presentation: 'Roll width', klass_scope: 'Design' },
      { name: 'roll length', presentation: 'Roll length', klass_scope: 'Design' },
      { name: 'repeat height', presentation: 'Repeat height', klass_scope: 'Design' },
      { name: 'repeat length', presentation: 'Repeat length', klass_scope: 'Design' },
      { name: 'mural width', presentation: 'Mural width', klass_scope: 'Design' },
      { name: 'mural height', presentation: 'Mural height', klass_scope: 'Design' },
      { name: 'match type', presentation: 'Match type', klass_scope: 'Design' },
      { name: 'printed width', presentation: 'Printed width', klass_scope: 'Design' },
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
