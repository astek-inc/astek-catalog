class CreateJoinTableProductTypesWebsites < ActiveRecord::Migration
  def change
    create_join_table :product_types, :websites do |t|
      t.index [:product_type_id, :website_id]
      t.index [:website_id, :product_type_id]
    end
  end
end
