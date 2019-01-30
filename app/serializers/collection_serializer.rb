class CollectionSerializer < ActiveModel::Serializer

  attributes :id, :product_type_id, :name, :description, :keywords

  belongs_to :product_type
  # has_many :designs

  link :self do
    api_v1_collection_path object
  end

  link :product_type do
    api_v1_product_type_path object.product_type
  end

  # link :designs do
  #   api_v1_collection_designs_path object
  # end

end
