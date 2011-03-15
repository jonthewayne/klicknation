CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp') # for carrierwave to work on heroku
  config.cache_dir = 'uploads' # for carrierwave to work on heroku
  #config.s3_cnamed = true # for klicknation- this uses the bucket name w/o s3.amazonaws.com in the url before the file path
  config.s3_access_key_id = '0AB2FSRPBZ089M8Q87G2' # klicknation: AKIAJWZ76CTUQP7JPEYQ
  config.s3_secret_access_key = '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' # klicknation: vcMvUSIeD24QO6RWkSjmDjPvaejbMCBbg6WbrX8t
  config.s3_bucket = 'klicknation-test' # klicknation: assets100.klicknation.com
end


#CarrierWave.configure do |config|
#  config.fog_credentials = {
#    :provider               => 'AWS',       # required
#    :aws_access_key_id      => '0AB2FSRPBZ089M8Q87G2',       # required
#    :aws_secret_access_key  => '0AlSrSkDMFOfVcdt4T5GhpTq6ZsYNyROudH0fyrv',       # required
#    #:region                 => 'us-west-1'  # optional, defaults to 'us-east-1'
#  }
#  config.fog_directory  = 'klicknation-test' # required, aka bucket if using S3. 
#  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
#  #config.fog_public     = false                                   # optional, defaults to true
#  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
#end
