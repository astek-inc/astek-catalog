class UpdatePanoramicImagesSkus < ActiveRecord::Migration[5.2]

  COLLECTIONS = ['Urbana', 'National Parks', 'Wanderlust']

  def up
    COLLECTIONS.each do |name|
      Collection.find_by(name: name).designs.each do |d|
        d.update_attribute('sku', 'PI'+d.sku)
        d.variants.each do |v|
          v.update_attribute('sku', 'PI'+v.sku)
        end
      end
    end

    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
