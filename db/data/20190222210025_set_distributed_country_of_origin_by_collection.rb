class SetDistributedCountryOfOriginByCollection < ActiveRecord::Migration

  COLLECTIONS = [
      { name: 'Desire', country_iso: 'HK' },
      { name: 'Earthly Delights', country_iso: 'HK' },
      { name: 'Entwine', country_iso: 'HK' },
      { name: 'Indulgence', country_iso: 'HK' },
      { name: 'Majestic Metallics', country_iso: 'HK' },
      { name: 'Moonlit Mica', country_iso: 'HK' },
      { name: 'Second Nature', country_iso: 'HK' },
      { name: 'Sheer Intuition', country_iso: 'JP' },
      { name: 'Shimmer', country_iso: 'JP' }
  ]

  def up
    COLLECTIONS.each do |col|
      sql = "UPDATE designs SET country_id = (SELECT id FROM countries WHERE iso = '#{col[:country_iso]}')
         WHERE collection_id = (SELECT id FROM collections WHERE name = '#{col[:name]}')"
      ActiveRecord::Base.connection.exec_query(sql)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
