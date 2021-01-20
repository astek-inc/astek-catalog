class RemoveSubstrateIdFromVariants < ActiveRecord::Migration[5.2]
  def change
    remove_column(:variants, :substrate_id)
  end
end
