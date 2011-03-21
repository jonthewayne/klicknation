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
  #process :resize_to_fill => [90,90]

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :card do
    process :resize_to_fill => [150,150]
  end
  
  version :original do
    process :resize_to_fill => [90,90]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png x-png)
  end

  # Override the filename of the uploaded files:
  def filename
    if original_filename
      if model.new_record?
        # last id + 1 will always be an id that's as yet unassociated with any other item
        "#{Digest::MD5.hexdigest("#{Item.last.id + 1}")[0,10]}.#{original_filename.split('.').last}"
      else
        # for exisiting records, use current photo's name or create a name off model id if photo's empty
        (model[:photo] && model[:photo] != '') ? model[:photo].split('/').last : "#{Digest::MD5.hexdigest("#{model.id + 1}")[0,10]}.#{original_filename.split('.').last}"
      end
    end
  end
  
  # override identifier to store full url instead of just filename
  def identifier
    url
  end
end

#module CarrierWave
#  module Mount
#    class Mounter
      # this allows me to store the full url in the photo column, instead of just the file name
#      def write_identifier
#        if remove?
#          record.write_uploader(serialization_column, '')
#        elsif not uploader.identifier.blank?
#          f = CarrierWave::Storage::S3::File.new(uploader, self, uploader.store_path)
#          record.write_uploader(serialization_column, f.public_url)
#        end
#      end
#    end
#  end
#end

module CarrierWave
  module Storage   
    class S3 < Abstract
      def retrieve!(identifier)
        # Strip the path from the identifier so that store_path only gets passed the filename it's used to
        CarrierWave::Storage::S3::File.new(uploader, self, uploader.store_path(identifier.split('/').last))
      end  
    end # S3
  end # Storage
end # CarrierWave

module CarrierWave
  module Uploader
    module Store
      def store_path(for_file=filename)
        the_filename = full_filename(for_file)
        if (the_version_name = version_name.to_s) != ''
          # remove version_ from beginning of filename
          the_filename = the_filename.split("#{the_version_name}_").last
          the_version_name = (the_version_name.include? "original") ? "" : "_#{the_version_name}"
          File.join([store_dir, "#{the_filename.split('.').first}#{the_version_name}.#{the_filename.split('.').last}"].compact)
        else
          File.join([store_dir, the_filename].compact)
        end
      end
    end # Store
  end # Uploader
end # CarrierWave
