class PopulateCountries < ActiveRecord::Migration

  DATA_DIR = 'data'
  DATA_FILE = 'countries.csv'

  require 'csv'
  # require 'pp'


  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|

      item = OpenStruct.new(row.to_h)
      # puts item.name

      # puts sprintf('%03d', item.numcode)

      Country.create! ({
          id: item.id,
          name: item.name,
          iso_name: item.iso_name,
          iso: item.iso,
          iso3: item.iso3,
          numcode: sprintf('%03d', item.numcode),
          currency_id: item.currency_id
      })

    end

    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
