class PopulateBackingTypes < ActiveRecord::Migration
  def up
    %w[Woven Non-woven Paper].each do |t|
      BackingType.create(name: t)
    end
  end

  def down
    BackingType.destroy_all
  end
end
