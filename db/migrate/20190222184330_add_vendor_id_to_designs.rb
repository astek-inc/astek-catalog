class AddVendorIdToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :vendor_id, :integer
    add_foreign_key :designs, :vendors

    Collection.all.each do |c|
      c.designs.each do |d|
        d.update_attribute(:vendor_id, c.vendor_id)
      end
    end
  end
end
