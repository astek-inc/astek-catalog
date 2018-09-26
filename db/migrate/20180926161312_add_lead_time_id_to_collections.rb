class AddLeadTimeIdToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :lead_time_id, :integer
    add_foreign_key :collections, :lead_times
  end
end
