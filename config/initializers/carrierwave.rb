require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.enable_processing = false

  if Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.fog_public = false
    config.fog_directory = ENV['AWS_BUCKET']
    config.fog_credentials = {
      provider: 'AWS',
      region: ENV['AWS_REGION'],
      aws_access_key_id: ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key: ENV['AWS_SECRET_KEY']
    }
    config.storage = :fog
  else
    config.root = File.join(Rails.root, 'public')
    config.asset_host = ENV['ASSET_HOST']
    config.storage = :file
  end
end
