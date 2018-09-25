class RemoveKlassScopeFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :klass_scope
  end
end
