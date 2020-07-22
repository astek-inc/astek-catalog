class DesignAlias < ApplicationRecord

  resourcify

  include RankedModel
  ranks :row_order, with_same: :collection_id

  include Websiteable

  belongs_to :collection
  belongs_to :design

  def handle
    if self.design.name == self.design.sku
      'da-' + self.id.to_s
    else
      self.design.name.parameterize + '-da-' + self.id.to_s
    end
  end

end
