class SetDesignSkus < ActiveRecord::Migration
  def up
    Design.all.each do |design|
      design.sku = design.variants.first.sku.gsub(/-\d\z/, '')
      design.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
