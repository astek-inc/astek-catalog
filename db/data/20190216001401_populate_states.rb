class PopulateStates < ActiveRecord::Migration

  DATA_DIR = 'data'
  DATA_FILE = 'states.csv'

  require 'csv'
  # require 'pp'


  def up
    path = File.join(__dir__, DATA_DIR, DATA_FILE)
    csv = CSV.read(path, headers: true)

    csv.each do |row|

      item = OpenStruct.new(row.to_h)
      # puts item.name

      State.create! ({
          id: item.id,
          name: item.name,
          abbr: item.abbr,
          country_id: item.country_id
      })
    end

    # raise
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
