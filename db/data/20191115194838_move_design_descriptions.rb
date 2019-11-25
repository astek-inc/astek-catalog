class MoveDesignDescriptions < ActiveRecord::Migration[5.2]
  def up
    Design.all.each do |d|
      if d.description?
        d.descriptions.create!(description: d.description, websites: d.websites)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
