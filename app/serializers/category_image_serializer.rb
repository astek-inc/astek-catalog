class ProductTypeImageSerializer < ActiveModel::Serializer

  attributes :id, :file, :type, :owner_id

  # belongs_to :product_type

  # link :self do
  #   api_v1_product_type_image_path object
  # end

  # link :product_type do
  #   api_v1_product_type_path object.product_type
  # end

end
