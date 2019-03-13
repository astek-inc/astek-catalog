class MoveVendorIdFromCollectionsToDesigns < ActiveRecord::Migration
  def up
    sql = "UPDATE designs SET vendor_id = (SELECT vendor_id FROM collections WHERE id = designs.collection_id)"
    ActiveRecord::Base.connection.exec_query(sql)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
