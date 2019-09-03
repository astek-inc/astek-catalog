class PopulateContactPaperSubcollections < ActiveRecord::Migration[5.2]

  DATA = [
      { name: 'Riffelblech', skus: ['210-0060', '210-5060'] },
      { name: 'Platinum Silver', skus: ['202-1203', '202-5203'] },
      { name: 'Mirror', skus: ['215-0001', '215-0002'] },
      { name: 'Whitewood', skus: ['200-1899', '200-5226'] },
      { name: 'Whitewood - Matte', skus: ['200-2741', '200-5393'] },
      { name: 'Nordic Elm', skus: ['200-3241', '200-5604'] },
      { name: 'Mother of Pearl', skus: ['200-2602', '200-5367'] },
      { name: 'White Ash', skus: ['200-2228', '200-5314'] },
      { name: 'Santana Oak', skus: ['200-3188', '200-5584'] },
      { name: 'Birch', skus: ['200-2875', '200-5475'] },
      { name: 'Maple', skus: ['200-2660', '200-5417'] },
      { name: 'Beech', skus: ['200-2816', '200-5427'] },
      { name: 'Beech Planks', skus: ['200-2608', '200-5356'] },
      { name: 'European Beech', skus: ['200-2658', '200-5418'] },
      { name: 'Erie Bright', skus: ['200-2906', '200-5506'] },
      { name: 'Japanese Oak', skus: ['200-2223', '200-5269'] },
      { name: 'Sheffield Oak', skus: ['200-3190', '200-5588'] },
      { name: 'Japanese Elm', skus: ['200-1604', '200-5157'] },
      { name: 'Cottage Pine', skus: ['200-2236', '200-5315'] },
      { name: 'Erie Medium', skus: ['200-2904', '200-5504'] },
      { name: 'Bright Oak', skus: ['200-2163', '200-5249'] },
      { name: 'Ribbeck Oak', skus: ['200-3240', '200-5603'] },
      { name: 'Sanremo Oak', skus: ['200-3230', '200-5597'] },
      { name: 'Rustic', skus: ['200-2813', '200-5424'] },
      { name: 'Sonoma Oak', skus: ['200-3218', '200-5595'] },
      { name: 'Sheffield Oak - Pearl Grey', skus: ['200-3186', '200-5582'] },
      { name: 'Sonoma Oak - Truffle', skus: ['200-3199', '200-5593'] },
      { name: 'Sonoma Oak - Sepia', skus: ['200-3217', '200-5594'] },
      { name: 'Calvados', skus: ['200-2986', '200-5519'] },
      { name: 'Walnut', skus: ['200-1844', '200-5200'] },
      { name: 'Rustic Oak', skus: ['200-2165', '200-5251'] },
      { name: 'Dark Mahogany', skus: ['200-2227', '200-5271'] },
      { name: 'Walnut', skus: ['200-1682', '200-5176'] },
      { name: 'Dark Maroon', skus: ['200-2234', '200-5444'] },
      { name: 'Sheffield Oak - Umbra', skus: ['200-3189', '200-5585'] },
      { name: 'Blackwood', skus: ['200-1700', '200-5180'] },
      { name: 'Marble - Grey', skus: ['200-2256', '200-5312'] },
      { name: 'Marble - White', skus: ['200-2254', '200-5277'] },
      { name: 'Carrara - Grey', skus: ['200-2614', '200-5357'] },
      { name: 'Carrara - Beige', skus: ['200-2615', '200-5358'] },
      { name: 'Romeo', skus: ['200-3242', '200-5605'] },
      { name: 'Marble - Black and White', skus: ['200-2713', '200-5391'] },
      { name: 'Cortes - Brown', skus: ['200-2455', '200-5321'] },
      { name: 'Porrinho - Grey', skus: ['200-2574', '200-5404'] },
      { name: 'Porrinho - Beige', skus: ['200-2573', '200-5403'] },
      { name: 'Brick', skus: ['200-2158', '200-5590'] },
      { name: 'Textile - Natural', skus: ['200-2850', '200-5450'] },
      { name: 'Leather - White', skus: ['200-2840', '200-5565'] },
      { name: 'Glossy - Gold Havana', skus: ['200-1920', '200-5451'] },
      { name: 'Leather - Black', skus: ['200-1923', '200-5287'] },
      { name: 'Glossy - White', skus: ['200-1273', '200-5145'] },
      { name: 'Glossy - Black', skus: ['200-1272', '200-5259'] },
      { name: 'Matte - White', skus: ['200-0100', '200-5001'] },
      { name: 'Matte - Black', skus: ['200-0111', '200-5010'] },
      { name: 'Metallic Brushed Silver', skus: ['210-0045', '210-8045'] }
  ]

  def up
    collection = Collection.find_by(name: 'Contact Paper')
    type = SubcollectionType.find_or_create_by!(name: 'Roll Width')
    DATA.each do |item|
      designs = Design.where(sku: item[:skus])
      Subcollection.create!(collection: collection, name: item[:name], subcollection_type: type, designs: designs)
    end
  end

  def down
    Collection.find_by(name: 'Contact Paper').subcollections.each do |s|
      s.designs.each do |d|
        d.update_attribute('subcollection_id', nil)
      end
      s.destroy
    end
  end
end
