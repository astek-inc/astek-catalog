class CreateJoinTableDesignsStyles < ActiveRecord::Migration
  def change
    create_join_table :designs, :styles do |t|
      t.index [:design_id, :style_id]
      t.index [:style_id, :design_id]
    end
  end
end
