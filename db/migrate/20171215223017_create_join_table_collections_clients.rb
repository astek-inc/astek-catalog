class CreateJoinTableCollectionsClients < ActiveRecord::Migration
  def change
    create_join_table :collections, :clients do |t|
      t.index [:collection_id, :client_id]
      t.index [:client_id, :collection_id]
    end
  end
end
