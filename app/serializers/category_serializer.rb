class ProductTypeSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :keywords, :slug

  has_many :product_type_images
  has_many :collections

  link :self do
    api_v1_product_type_path object
  end

  # link :product_type_images do
  #   api_v1_product_type_product_type_images_path object
  # end

  link :collections do
    api_v1_product_type_collections_path object
  end

end
