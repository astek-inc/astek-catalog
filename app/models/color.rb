class Color < ActiveRecord::Base

  resourcify

  include RankedModel
  ranks :row_order

  has_and_belongs_to_many :variants

  validates :name, presence: true, uniqueness: true

end
