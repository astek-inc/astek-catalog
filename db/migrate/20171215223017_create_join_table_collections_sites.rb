class CreateJoinTableCollectionsSites < ActiveRecord::Migration
  def change
    create_join_table :collections, :sites do |t|
      t.index [:collection_id, :site_id]
      t.index [:site_id, :collection_id]
    end
  end
end
