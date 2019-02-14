class AddDisplayNameToSubstrates < ActiveRecord::Migration
  def change
    add_column :substrates, :display_name, :string
  end
end
