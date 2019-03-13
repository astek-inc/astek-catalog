class SetDigitalLibraryPackageDimensions < ActiveRecord::Migration
  def up
    Collection.find_by(name: 'Digital Library').designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: 7, height: 7, depth: 60 })
      end
    end
  end

  def down
    Collection.find_by(name: 'Digital Library').designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: nil, height: nil, depth: nil })
      end
    end
  end
end
