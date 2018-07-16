class CreateJoinTableDesignsSubstrates < ActiveRecord::Migration
  def change
    create_join_table :designs, :substrates do |t|
      t.index [:design_id, :substrate_id]
      t.index [:substrate_id, :design_id]
    end
  end
end
