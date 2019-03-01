class SetDistributedCountryOfOriginByVendor < ActiveRecord::Migration

  VENDORS = [
      { name: 'Anaglypta', country_iso: 'GB' },
      { name: 'Asiana', country_iso: 'CN' },
      { name: 'BN', country_iso: 'GB' },
      { name: 'Capiz Shells', country_iso: 'TW' },
      { name: 'd-c-fix', country_iso: 'DE' },
      { name: 'Lincrusta', country_iso: 'GB' },
      { name: 'Marburg', country_iso: 'DE' },
      { name: 'MJF', country_iso: 'US' },
      { name: 'Nina Hancock', country_iso: 'GB' },
      { name: 'Omni', country_iso: 'US' },
      { name: 'Rotex', country_iso: 'TW' },
      { name: 'Tokiwa', country_iso: 'JP' },
      { name: 'Tokyo', country_iso: 'JP' },
      { name: 'Wallquest', country_iso: 'US' },
  ]

  def up

    VENDORS.each do |vendor|
      sql = "UPDATE
          designs
        SET
          country_id = (SELECT id FROM countries WHERE iso = '#{vendor[:country_iso]}')
        WHERE
          vendor_id = (SELECT id FROM vendors WHERE name = '#{vendor[:name]}')"
      ActiveRecord::Base.connection.exec_query(sql)
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
