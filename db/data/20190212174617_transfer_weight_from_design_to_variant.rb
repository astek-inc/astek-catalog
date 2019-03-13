class TransferWeightFromDesignToVariant < ActiveRecord::Migration
  def up
    Design.all.each do |design|
      design.variants.each do |variant|
        variant.update_attribute :weight, design.weight
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
