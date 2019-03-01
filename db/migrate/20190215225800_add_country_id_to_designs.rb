class AddCountryIdToDesigns < ActiveRecord::Migration
  def change
    add_column :designs, :country_id, :integer
    add_foreign_key :designs, :countries
  end
end
