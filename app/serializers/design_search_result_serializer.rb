class DesignSearchResultSerializer < ActiveModel::Serializer

  attribute :id
  attribute :name
  attribute :name, key: :value

end
