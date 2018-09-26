class PopulateLeadTimes < ActiveRecord::Migration

  LEAD_TIMES = [
      {name: '1-2 weeks' },
      {name: '3-6 weeks' },
      {name: '6-8 weeks' }
  ]

  def up
    LEAD_TIMES.each do |t|
      LeadTime.create! t
    end
  end

  def down
    LeadTime.destroy_all
  end
end
