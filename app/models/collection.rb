class Collection < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :category_id

  acts_as_paranoid

  belongs_to :category
  has_many :designs, dependent: :destroy
  has_many :collection_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy
  has_and_belongs_to_many :sites

end
