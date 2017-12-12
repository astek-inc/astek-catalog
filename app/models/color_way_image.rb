class ColorWayImage < Image
  belongs_to :color_way
  mount_uploader :file, ColorWayImageUploader
  skip_callback :commit, :after, :remove_file! # To work with acts_as_paranoid
end
