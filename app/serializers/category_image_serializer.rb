class CategoryImageSerializer < ActiveModel::Serializer

  attributes :id, :file, :type, :owner_id

  # belongs_to :category

  # link :self do
  #   api_v1_category_image_path object
  # end

  # link :category do
  #   api_v1_category_path object.category
  # end

end
