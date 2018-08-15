class Website < ActiveRecord::Base

  resourcify

  acts_as_paranoid

  validates :name, presence: true
  validates :domain, presence: true, uniqueness: { scope: :deleted_at }

  default_scope { order(name: :asc) }

  has_and_belongs_to_many :collections

end
