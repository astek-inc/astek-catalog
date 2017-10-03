class Collection < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :category_id

  acts_as_paranoid

  belongs_to :category
  has_many :designs
  has_many :collection_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

end
