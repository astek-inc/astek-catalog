class CategorySerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :keywords, :slug

  has_many :category_images
  has_many :collections

  link :self do
    api_v1_category_path object
  end

  # link :category_images do
  #   api_v1_category_category_images_path object
  # end

  link :collections do
    api_v1_category_collections_path object
  end

end
