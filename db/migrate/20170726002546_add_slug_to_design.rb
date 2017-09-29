class AddSlugToDesign < ActiveRecord::Migration
  def change
    add_column :designs,:slug, :string
    add_index :designs, :slug, unique: true
  end
end
