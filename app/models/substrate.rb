class Substrate < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  has_many :substrate_images, -> { order(row_order: :asc) }, foreign_key: 'owner_id', dependent: :destroy
  has_many :variants
  belongs_to :backing_type
  has_and_belongs_to_many :substrate_categories

  # Custom materials should really be associated with Colorways (variants),
  # but the website only displays material options by design
  has_many :custom_materials, dependent: :destroy, inverse_of: :substrate
  has_many :designs, through: :custom_materials

  default_scope { order(name: :asc) }

  validates :name, presence: true

  def formatted_name
    if self.display_name
      "#{self.name} (#{self.display_name})"
    else
      self.name
    end
  end

end
