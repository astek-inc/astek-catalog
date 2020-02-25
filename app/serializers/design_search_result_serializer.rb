class DesignSearchResultSerializer < ActiveModel::Serializer

  attributes :id, :name, :value

  def value
    "#{object.name} (#{object.sku})"
  end

end
