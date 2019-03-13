class SetMetallicIllusionsVVendorsAndCountryOfOrigin < ActiveRecord::Migration
  
  DATA = [
      { sku: 'MI601', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI602', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI603', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI604', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI605', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI606', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI607', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI608', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI609', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI610', vendor: 'Rotex', country_of_origin: 'TW' },
      { sku: 'MI611', vendor: 'Rotex', country_of_origin: 'TW' },
      { sku: 'MI612', vendor: 'Rotex', country_of_origin: 'TW' },
      { sku: 'MI613', vendor: 'Rotex', country_of_origin: 'TW' },
      { sku: 'MI614', vendor: 'Rotex', country_of_origin: 'TW' },
      { sku: 'MI615', vendor: 'Rotex', country_of_origin: 'TW' },
      { sku: 'MI616', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI617', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI618', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI619', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI620', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI621', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI622', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI623', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI624', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI625', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI626', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI627', vendor: 'Roysons', country_of_origin: 'US' },
      { sku: 'MI628', vendor: 'Roysons', country_of_origin: 'US' },
      { sku: 'MI629', vendor: 'Roysons', country_of_origin: 'US' },
      { sku: 'MI630', vendor: 'Roysons', country_of_origin: 'US' },
      { sku: 'MI631', vendor: 'Roysons', country_of_origin: 'US' },
      { sku: 'MI633', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI634', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI635', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI636', vendor: 'Roysons', country_of_origin: 'US' },
      { sku: 'MI637', vendor: 'Roysons', country_of_origin: 'US' },
      { sku: 'MI638', vendor: 'Tokiwa', country_of_origin: 'JP' },
      { sku: 'MI639', vendor: 'Tokiwa', country_of_origin: 'JP' },
      { sku: 'MI640', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI641', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI642', vendor: 'Tokyo', country_of_origin: 'JP' },
      { sku: 'MI643', vendor: 'Tokyo', country_of_origin: 'JP' },
  ]
  
  def up
    DATA.each do |item|
      sql = "UPDATE
          designs
        SET
          country_id = (SELECT id FROM countries WHERE iso = '#{item[:country_of_origin]}'),
          vendor_id = (SELECT id FROM vendors WHERE name ='#{item[:vendor]}')
        WHERE
          sku = '#{item[:sku]}'"
      ActiveRecord::Base.connection.exec_query(sql)
    end
  end

  def down
    DATA.each do |item|
      sql = "UPDATE
          designs
        SET
          country_id = NULL,
          vendor_id = NULL
        WHERE
          sku = '#{item[:sku]}'"
      ActiveRecord::Base.connection.exec_query(sql)
    end
  end
end
