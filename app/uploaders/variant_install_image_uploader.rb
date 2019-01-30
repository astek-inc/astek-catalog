class VariantInstallImageUploader < ImageUploader

  # Create different versions of your uploaded files:
  version :large do
    process resize_to_fit: [1000, 600]
  end

  version :small do
    process resize_to_fit: [250, 150]
  end

  version :thumb do
    process resize_to_fit: [50, 30]
  end

end
