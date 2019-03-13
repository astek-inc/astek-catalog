class SetLincrustaPackageDimensions < ActiveRecord::Migration

  DATA = [
      { sku: 'RD1583', width: '7', height: '7', depth: '25' },
      { sku: 'RD1639', width: '6', height: '6', depth: '6' },
      { sku: 'RD1640', width: '6', height: '6', depth: '6' },
      { sku: 'RD1650', width: '7', height: '7', depth: '25' },
      { sku: 'RD1805', width: '7', height: '7', depth: '25' },
      { sku: 'RD1827', width: '7', height: '7', depth: '25' },
      { sku: 'RD1843', width: '7', height: '7', depth: '25' },
      { sku: 'RD1860', width: '7', height: '7', depth: '25' },
      { sku: 'RD1873', width: '7', height: '7', depth: '25' },
      { sku: 'RD1888', width: '7', height: '7', depth: '25' },
      { sku: 'RD1893', width: '7', height: '7', depth: '25' },
      { sku: 'RD1902', width: '7', height: '7', depth: '25' },
      { sku: 'RD1903', width: '7', height: '7', depth: '25' },
      { sku: 'RD1946', width: '6', height: '6', depth: '12' },
      { sku: 'RD1947', width: '6', height: '6', depth: '12' },
      { sku: 'RD1948', width: '6', height: '6', depth: '12' },
      { sku: 'RD1949', width: '6', height: '6', depth: '12' },
      { sku: 'RD1952', width: '7', height: '7', depth: '25' },
      { sku: 'RD1953', width: '6', height: '6', depth: '6' },
      { sku: 'RD1954', width: '6', height: '6', depth: '6' },
      { sku: 'RD1955', width: '7', height: '7', depth: '25' },
      { sku: 'RD1956', width: '7', height: '7', depth: '25' },
      { sku: 'RD1957', width: '6', height: '6', depth: '12' },
      { sku: 'RD1958', width: '6', height: '6', depth: '12' },
      { sku: 'RD1960', width: '7', height: '7', depth: '25' },
      { sku: 'RD1962', width: '7', height: '7', depth: '25' },
      { sku: 'RD1963', width: '7', height: '7', depth: '25' },
      { sku: 'RD1964', width: '7', height: '7', depth: '25' },
      { sku: 'RD1965', width: '7', height: '7', depth: '25' },
      { sku: 'RD1966', width: '7', height: '7', depth: '25' },
      { sku: 'RD1967', width: '7', height: '7', depth: '25' },
      { sku: 'RD1968', width: '7', height: '7', depth: '25' },
      { sku: 'RD1969', width: '7', height: '7', depth: '25' },
      { sku: 'RD1970', width: '7', height: '7', depth: '25' },
      { sku: 'RD1971', width: '7', height: '7', depth: '25' },
      { sku: 'RD1972', width: '7', height: '7', depth: '25' },
      { sku: 'RD1975', width: '7', height: '7', depth: '25' },
      { sku: 'RD1976', width: '7', height: '7', depth: '25' },
      { sku: 'RD1978', width: '7', height: '7', depth: '25' },
  ]

  def up
    DATA.each do |item|
      v = Variant.find_by(sku: item[:sku])
      v.update_attributes({ width: item[:width], height: item[:height], depth: item[:depth]})
    end

  end

  def down
    DATA.each do |item|
      v = Variant.find_by(sku: item[:sku])
      v.update_attributes({ width: nil, height: nil, depth: nil})
    end
  end
end
