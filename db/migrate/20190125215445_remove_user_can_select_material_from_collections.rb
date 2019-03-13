class RemoveUserCanSelectMaterialFromCollections < ActiveRecord::Migration
  def change
    remove_column(:collections, :user_can_select_material)
  end
end
