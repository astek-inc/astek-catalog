class SetHollywoodDazzleIiiPackageDimensions < ActiveRecord::Migration
  def up
    Collection.find_by(name: 'Hollywood Dazzle III').designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: 6, height: 6, depth: 38 })
      end
    end
  end

  def down
    Collection.find_by(name: 'Hollywood Dazzle III').designs.each do |d|
      d.variants.each do |v|
        v.update_attributes({ width: nil, height: nil, depth: nil })
      end
    end
  end
end
