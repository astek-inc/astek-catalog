class CreateJoinTableCollectionsWebsites < ActiveRecord::Migration
  def change
    create_join_table :collections, :websites do |t|
      t.index [:collection_id, :website_id]
      t.index [:website_id, :collection_id]
    end
  end
end
