class RemoveProductCategoryIdFromProductTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column(:product_types, :product_category_id)
  end
end
