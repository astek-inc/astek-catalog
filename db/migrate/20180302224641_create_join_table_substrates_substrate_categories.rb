class CreateJoinTableSubstratesSubstrateCategories < ActiveRecord::Migration
  def change
    create_join_table :substrates, :substrate_categories do |t|
      t.index [:substrate_category_id, :substrate_id], name: 'idx_substr_cats_substrs_on_substr_cat_id_and_substr_id'
      t.index [:substrate_id, :substrate_category_id], name: 'idx_substrs_substr_cats_on_substr_id_and_substr_cat_id'
    end
  end
end
