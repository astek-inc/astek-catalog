class AddAppendCollectionNameToDesignNamesToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :append_collection_name_to_design_names, :boolean, default: :false, null: false
  end
end


