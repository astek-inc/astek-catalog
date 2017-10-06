class CollectionSerializer < ActiveModel::Serializer

  attributes :id, :category_id, :name, :description, :keywords, :slug

  belongs_to :category
  # has_many :designs

  link :self do
    api_v1_collection_path object
  end

  link :category do
    api_v1_category_path object.category
  end

  # link :designs do
  #   api_v1_collection_designs_path object
  # end

end
