class RemoveUserCanSelectMaterialFromDesigns < ActiveRecord::Migration[5.2]
  def change
    remove_column :designs, :user_can_select_material
  end
end
