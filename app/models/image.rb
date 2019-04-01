class Image < ApplicationRecord

  resourcify

  include RankedModel
  ranks :row_order, with_same: :owner_id

  acts_as_paranoid

end
