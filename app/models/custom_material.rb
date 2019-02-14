class CustomMaterial < ActiveRecord::Base

  resourcify

  # Custom materials should really be associated with Colorways (variants),
  # but the website only displays material options by design
  belongs_to :design
  belongs_to :substrate

  validates :design_id, presence: true
  validates :substrate_id, presence: true

  # validates :default_material, uniqueness: {
  #     scope: :design_id,
  #     unless: false,
  #     message: 'must be unique per design'
  # }
  #

  def name
    self.substrate.display_name ? self.substrate.display_name : self.substrate.name
  end

  def surcharge
    self.substrate.custom_material_surcharge
  end

end
