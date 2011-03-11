CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => '0AB2FSRPBZ089M8Q87G2',       # required
    :aws_secret_access_key  => '0AlSrSkDMFOfVcdt4T5GhpTq6ZsYNyROudH0fyrv',       # required
    #:region                 => 'us-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'klicknation-test' # required, aka bucket if using S3. 
  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  #config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
