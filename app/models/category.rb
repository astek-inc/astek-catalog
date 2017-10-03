class Category < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order

  acts_as_paranoid

  has_many :collections, inverse_of: :category
  has_many :category_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy

end
