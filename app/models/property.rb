class Property < ActiveRecord::Base

  resourcify

  has_many :design_properties, dependent: :delete_all, inverse_of: :property
  has_many :designs, through: :design_properties

  validates :name, :presentation, :klass_scope, presence: true
  validates :name, uniqueness: { scope: :klass_scope }
  validates :name, format: { with: /\A[a-z0-9_]+\z/, message: 'only allows lower-case letters, numerals, and underscores' }

  default_scope { order(:name) }

end
