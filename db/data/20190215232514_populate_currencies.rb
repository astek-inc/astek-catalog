class PopulateCurrencies < ActiveRecord::Migration

  DATA_DIR = 'data'
  DATA_FILE = 'currencies.csv'

  require 'csv'
  # require 'pp'


  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|

      item = OpenStruct.new(row.to_h)

      # puts item.code

      Currency.create! ({
        id: item.id,
        name: item.name,
        code: item.code,
        symbol: item.symbol,
        symbol_position: item.symbol_position
      })

    end

    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
