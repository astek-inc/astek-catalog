class AddSuppressSampleOptionFromDisplayToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :suppress_sample_option_from_display, :boolean, default: :false, null: false
  end
end
