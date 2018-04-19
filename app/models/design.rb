class Design < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :collection_id

  acts_as_paranoid

  default_scope { order(created_at: :desc) }

  belongs_to :collection
  has_many :variants, dependent: :destroy

  has_many :design_properties, dependent: :destroy, inverse_of: :design
  has_many :properties, through: :design_properties

  accepts_nested_attributes_for :design_properties, allow_destroy: true, reject_if: lambda { |pp| pp[:property_name].blank? }

end
