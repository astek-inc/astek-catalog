class RemoveSuppressFromSearchesFromVariants < ActiveRecord::Migration
  def change
    remove_column :variants, :suppress_from_searches, :boolean
  end
end
