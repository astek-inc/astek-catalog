class RemoveRowOrderFromLeadTimes < ActiveRecord::Migration
  def change
    remove_column :lead_times, :row_order
  end
end
