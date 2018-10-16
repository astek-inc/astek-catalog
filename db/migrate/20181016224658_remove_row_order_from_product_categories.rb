class RemoveRowOrderFromProductCategories < ActiveRecord::Migration
  def change
    remove_column :product_categories, :row_order
  end
end
