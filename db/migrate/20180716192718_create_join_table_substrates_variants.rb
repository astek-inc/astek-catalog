class CreateJoinTableSubstratesVariants < ActiveRecord::Migration
  def change
    create_join_table :substrates, :variants  do |t|
      t.index [:substrate_id, :variant_id]
      t.index [:variant_id, :substrate_id]
    end
  end
end
