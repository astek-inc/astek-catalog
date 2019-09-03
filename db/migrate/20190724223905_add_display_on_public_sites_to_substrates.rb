class AddDisplayOnPublicSitesToSubstrates < ActiveRecord::Migration[5.2]
  def change
    add_column :substrates, :display_on_public_sites, :boolean, default: false
  end
end
