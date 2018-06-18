class Color < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order

  has_and_belongs_to_many :variants

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, on: :update

end
