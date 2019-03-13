class SetFlashPackageDimensions < ActiveRecord::Migration

  COLLECTION = 'Flash'
  DIMENSIONS = %w[6 6 38]

  def up
    Collection.find_by(name: COLLECTION).designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: DIMENSIONS[0], height: DIMENSIONS[1], depth: DIMENSIONS[2] })
      end
    end
  end

  def down
    Collection.find_by(name: COLLECTION).designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: nil, height: nil, depth: nil })
      end
    end
  end

end
