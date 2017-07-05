class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process crop: :avatar
  process resize_to_fill 200, 200
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
