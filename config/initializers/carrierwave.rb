CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp') # for carrierwave to work on heroku
  config.cache_dir = 'uploads' # for carrierwave to work on heroku
  config.s3_cnamed = (ENV['S3_BUCKET'] == "assets100.klicknation.com") ? true : false # for klicknation- this uses the bucket name sans s3.amazonaws.com in the url before the file path
  config.s3_access_key_id = ENV['S3_KEY'] 
  config.s3_secret_access_key = ENV['S3_SECRET']
  config.s3_bucket = ENV['S3_BUCKET']
end


#CarrierWave.configure do |config|
#  config.fog_credentials = {
#    :provider               => 'AWS',       # required
#    :aws_access_key_id      => '',       # required
#    :aws_secret_access_key  => '',       # required
#    #:region                 => 'us-west-1'  # optional, defaults to 'us-east-1'
#  }
#  config.fog_directory  = 'klicknation-test' # required, aka bucket if using S3. 
#  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
#  #config.fog_public     = false                                   # optional, defaults to true
#  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
#end
