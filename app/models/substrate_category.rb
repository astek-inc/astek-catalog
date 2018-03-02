class SubstrateCategory < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order

  acts_as_paranoid

  has_and_belongs_to_many :substrates

  validates :name, presence: true

end
