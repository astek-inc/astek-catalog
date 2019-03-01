class SetVintagePackageDimensions < ActiveRecord::Migration

  COLLECTIONS = %w[Pre-1920s 1920s-1930s 1940s-1950s 1960s-1970s]

  def up
    COLLECTIONS.each do |name|
      Collection.find_by(name: name).designs.each do |d|
        d.variants.each do |v|
          v.update_attributes({ width: 7, height: 7, depth: 60 })
        end
      end
    end
  end

  def down
    COLLECTIONS.each do |name|
      Collection.find_by(name: name).designs.each do |d|
        d.variants.each do |v|
        v.update_attributes({ width: nil, height: nil, depth: nil })
        end
      end
    end
  end

end
