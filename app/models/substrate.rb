class Substrate < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order

  acts_as_paranoid

  has_many :substrate_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy
  has_many :variants
  belongs_to :backing_type
  has_and_belongs_to_many :substrate_categories

  validates :name, presence: true

end
