class SkuPrefix < ApplicationRecord

  resourcify

  default_scope { order(prefix: :asc) }

  validates :prefix, presence: true, uniqueness: true

  def option_value
    self.prefix + ' - ' + self.description
  end

end
