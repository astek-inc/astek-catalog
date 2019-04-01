class ProductTypeImage < Image
  belongs_to :product_type, foreign_key: :owner_id
  mount_uploader :file, ProductTypeImageUploader
  # skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
