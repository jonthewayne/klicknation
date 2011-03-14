# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "apps/heros/assets/abilities/" + %w(attack defense movement).insert(20,"attack","defense","movement")[model.type.to_i]
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_fill => [90,90]

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :card do
    process :resize_to_fill => [150,150]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png x-png)
  end

  # Override the filename of the uploaded files:
  def filename
    @tempname ||= ActiveSupport::SecureRandom.hex
    "#{File.extname(original_filename).downcase}#{@tempname}" if original_filename
  end
end

# monkey patch version.rb so that I can have file versions saved as filename_version.ext instead of version_filename.ext
module CarrierWave
  module Uploader
    module Versions
      private
      def full_filename(for_file)
        # [version_name, super(for_file)].compact.join('_') 
        the_filename = super(for_file)
        version_name ? (the_filename.split('.').first + "_" + version_name + "." + the_filename.split('.').last) : the_filename
      end

      def full_original_filename
        # [version_name, super].compact.join('_')
        the_filename = super
        version_name ? (the_filename.split('.').first + "_" + version_name + "." + the_filename.split('.').last) : the_filename        
      end
    end # Versions
  end # Uploader
end # CarrierWave


