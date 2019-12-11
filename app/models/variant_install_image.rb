class VariantInstallImage < Image

  include Websiteable

  belongs_to :variant, foreign_key: :owner_id
  mount_uploader :file, VariantInstallImageUploader
  # skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid

end
