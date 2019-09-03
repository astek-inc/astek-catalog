class AddDisplayDescriptionToSubstrates < ActiveRecord::Migration[5.2]
  def change
    add_column :substrates, :display_description, :text
  end
end
