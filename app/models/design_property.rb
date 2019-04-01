class DesignProperty < ApplicationRecord

  belongs_to :design, inverse_of: :design_properties
  belongs_to :property, inverse_of: :design_properties

  validates :property, presence: true

  include RankedModel
  ranks :row_order, with_same: :design_id

  # virtual attributes for use with AJAX completion stuff
  def property_name
    property.name if property
  end

  # def property_name=(name)
  #   if name.present?
  #     # don't use `find_by :name` to workaround globalize/globalize#423 bug
  #     property = Property.where(name: name).first || Property.create(name: name, presentation: name)
  #     self.property = property
  #   end
  # end

end
