class AddUserCanSelectMaterialToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :user_can_select_material, :boolean
  end
end
