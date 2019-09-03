class AddWeightPerSquareFootToSubstrates < ActiveRecord::Migration[5.2]
  def change
    add_column :substrates, :weight_per_square_foot, :decimal, precision: 5, scale: 2
  end
end
