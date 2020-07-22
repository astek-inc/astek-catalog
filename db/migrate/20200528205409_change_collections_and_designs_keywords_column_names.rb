class ChangeCollectionsAndDesignsKeywordsColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :collections, :keywords, :old_keywords
    rename_column :designs, :keywords, :old_keywords
  end
end
