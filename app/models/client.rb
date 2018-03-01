class Client < ActiveRecord::Base

  include Tokenable

  resourcify

  acts_as_paranoid

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :collections

  validates :name, presence: true
  validates :domain, presence: true, uniqueness: { scope: :deleted_at }

  default_scope { order(name: :asc) }

end
