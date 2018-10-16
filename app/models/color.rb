class Color < ActiveRecord::Base

  resourcify

  has_and_belongs_to_many :variants

  default_scope { order(name: :asc) }

  validates :name, presence: true, uniqueness: true

end
