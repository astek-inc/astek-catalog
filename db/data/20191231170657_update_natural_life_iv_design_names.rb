class UpdateNaturalLifeIvDesignNames < ActiveRecord::Migration[5.2]
  def up

    c = Collection.find_by(name: 'Natural Life IV')

    c.designs.each do |d|

      d.update_attribute('name', d.sku)
      
      d.variants.each do |v|

        v.update_attribute('name', d.sku)

        v.variant_swatch_images.each do |i|
          i.file.recreate_versions!
        end

        v.variant_install_images.each do |i|
          i.file.recreate_versions!
        end

      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
