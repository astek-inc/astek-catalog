class AddLeadTimesToCollections < ActiveRecord::Migration

  COLLECTIONS = [
    {name: 'Flash', lead_time: '3-6 weeks' },
    {name: 'Van Gogh', lead_time: '3-6 weeks' },
    {name: 'Curious', lead_time: '3-6 weeks' },
    {name: 'Sheer Intuition', lead_time: '3-6 weeks' },
    {name: 'Loft', lead_time: '3-6 weeks' },
    {name: 'Anaglypta', lead_time: '1-2 weeks' },
    {name: 'Riviera Maison', lead_time: '3-6 weeks' },
    {name: 'Exotic Naturals of Asia', lead_time: '3-6 weeks' },
    {name: 'Decadent', lead_time: '3-6 weeks' },
    {name: 'Fine Metals of Asia', lead_time: '3-6 weeks' },
  ]

  def up
    COLLECTIONS.each do |c|
      collection = Collection.find_by(name: c[:name])
      collection.lead_time_id = LeadTime.find_by!(name: c[:lead_time]).id
      collection.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
