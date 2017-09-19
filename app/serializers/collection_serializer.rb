class CollectionSerializer < ActiveModel::Serializer

  attributes :id, :category_id, :name, :description, :keywords, :slug

  belongs_to :category
  # has_many :designs

  link :self do
    api_v1_category_collection_path object.category, object
  end

  # link :designs do
  #   api_v1_collection_designs_path object
  # end

end
