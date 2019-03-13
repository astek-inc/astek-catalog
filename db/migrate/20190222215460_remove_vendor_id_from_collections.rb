class RemoveVendorIdFromCollections < ActiveRecord::Migration
  def change
    remove_column(:collections, :vendor_id)
  end
end
