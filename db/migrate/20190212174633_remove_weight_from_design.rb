class RemoveWeightFromDesign < ActiveRecord::Migration
  def change
    remove_column :designs, :weight
  end
end
