class CreateSkuPrefixes < ActiveRecord::Migration[5.2]
  
  PREFIXES = [
    { prefix: 'AD', separator: '', description: 'Standard Astek design prefix.' },
    { prefix: 'AV', separator: '', description: 'Astek vintage design prefix.' },
    { prefix: 'FP', separator: '', description: 'Designs in collaboration with Don Flood ("Fliepaper").' },
    { prefix: 'GB', separator: '', description: 'Designs in collaboration with Gary Baseman.' },
    { prefix: 'GWC', separator: '', description: 'Designs in collaboration with Genevieve White Carter.' },
    { prefix: 'JA', separator: '', description: 'Designs in collaboration with Jeff Andrews.' },
    { prefix: 'JF', separator: '', description: 'Designs in collaboration with Jim Flora.' },
    { prefix: 'KA', separator: '', description: '"Kahala" designs in collaboration with Pacific Textile Archive.' },
    { prefix: 'LM', separator: '', description: 'Designs in collaboration with Llew Mejia.' },
    { prefix: 'OA', separator: '-', description: 'Prefix for On Air Design collections.' },
    { prefix: 'PI', separator: '', description: 'Panoramic Images photographic murals.' },
    { prefix: 'SL', separator: '', description: 'Designs in collaboration with Steve LaVoie.' },
    { prefix: 'SOW', separator: '', description: 'Designs in collaboration with Society of Wonderland.' },
  ]
  
  def up
    create_table :sku_prefixes do |t|
      t.string :prefix, index: true
      t.string :separator
      t.text :description
      t.timestamps
      t.timestamp :deleted_at, index: true
    end

    PREFIXES.each do |prefix|
      SkuPrefix.create!(prefix)
    end
  end

  def down
    drop_table :sku_prefixes
  end
end
