class Design < ActiveRecord::Base

  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :collection_id

  acts_as_paranoid

  belongs_to :collection
  belongs_to :sale_unit

  has_many :variants, dependent: :destroy

  has_many :design_properties, dependent: :destroy, inverse_of: :design
  has_many :properties, through: :design_properties

  has_and_belongs_to_many :styles

  accepts_nested_attributes_for :design_properties, allow_destroy: true, reject_if: lambda { |pp| pp[:property_name].blank? }

  def property name
    self.design_properties.joins(:property).find_by(properties: { name: name }).try(:value)
  end

end
