class DesignImage < Image
  belongs_to :design
  mount_uploader :file, DesignImageUploader
  skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
