CarrierWave.configure do |config|

  config.fog_provider = 'fog/aws' # required
  config.fog_credentials = {
      provider: 'AWS', # required
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'], # required
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # required
      region: ENV['AWS_REGION'], # optional, defaults to 'us-east-1'
      host: 's3-'+ENV['AWS_REGION']+'.amazonaws.com', # optional, defaults to nil
      # endpoint: 'https://s3-'+ENV['AWS_REGION']+'.amazonaws.com' # optional, defaults to nil
  }

  config.fog_directory = ENV['AWS_S3_BUCKET_NAME'] # required
  config.fog_public = true #false # optional, defaults to true
  # config.fog_authenticated_url_expiration = (60 * 60 * 24 * 365)
  config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" } # optional, defaults to {}

end
