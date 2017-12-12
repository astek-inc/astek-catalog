class ColorWay < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :design_id

  acts_as_paranoid

  belongs_to :design
  has_many :color_way_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

end
