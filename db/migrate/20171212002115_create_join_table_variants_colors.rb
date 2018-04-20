class CreateJoinTableVariantsColors < ActiveRecord::Migration
  def change
    create_join_table :variants, :colors do |t|
      t.index [:variant_id, :color_id]
      t.index [:color_id, :variant_id]
    end
  end
end
