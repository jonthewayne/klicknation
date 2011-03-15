# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  #storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    #"apps/heros/assets/abilities/" + %w(attack defense movement).insert(20,"attack","defense","movement")[model.type.to_i]
    "uploads"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  #process :resize_to_fill => [150,150]

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  #version :card do
  #  process :resize_to_fill => [150,150]
  #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  #def extension_white_list
    #%w(jpg jpeg png x-png)
  #end

  # Override the filename of the uploaded files:
  def filename
    @last_item = model.new_record? ? Item.last.id + 1 : model.id
    "#{@last_item}-#{Digest::MD5.hexdigest("#{@last_item}")[0,6]}.#{original_filename.split('.').last}" if original_filename
  end
end

module CarrierWave
  module Mount
    class Mounter
      # this allows me to store the full url in the photo column, instead of just the file name
      def write_identifier
        if remove?
          record.write_uploader(serialization_column, '')
        elsif not uploader.identifier.blank?
          f = CarrierWave::Storage::S3::File.new(uploader, self, uploader.store_path)
          record.write_uploader(serialization_column, f.public_url)
        end
      end
    end
  end
end

module CarrierWave
  module Storage   
    # I just need to strip the path from my newly changed identifier so that store_path only gets passed a filename
    class S3 < Abstract
      def retrieve!(identifier)
        CarrierWave::Storage::S3::File.new(uploader, self, uploader.store_path(identifier.split('/').last))
      end  
    end # S3
  end # Storage
end # CarrierWave

# monkey patch version.rb so that I can have file versions saved as filename_version.ext instead of version_filename.ext
module CarrierWave
  module Uploader
    module Versions
      private
      def full_filename(for_file)
        [version_name, super(for_file)].compact.join('_') 
        #the_filename = super(for_file)
        #version_name ? (the_filename.split('.').first + "_" + version_name + "." + the_filename.split('.').last) : the_filename
      end

      def full_original_filename
        [version_name, super].compact.join('_')
        #the_filename = super
        #version_name ? (the_filename.split('.').first + "_" + version_name + "." + the_filename.split('.').last) : the_filename        
      end
    end # Versions
  end # Uploader
end # CarrierWave 


