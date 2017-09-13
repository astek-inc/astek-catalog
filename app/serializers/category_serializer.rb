class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :keywords, :link, :slug, :row_order_position
  # , :created_at, :updated_at, :deleted_at
  # has_many :collections
end
