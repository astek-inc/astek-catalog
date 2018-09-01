class PopulateDesignsProductTypes < ActiveRecord::Migration
  def up
    Design.all.each do |design|
      design.product_types << ProductType.find(design.product_type_id)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
