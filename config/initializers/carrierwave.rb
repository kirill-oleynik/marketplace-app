CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_public = false
    config.fog_directory = ENV['AWS_BUCKET']
    config.fog_credentials = {
      provider: 'AWS',
      region: ENV['AWS_REGION'],
      aws_access_key_id: ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key: ENV['AWS_SECRET_KEY']
    }
  else
    config.storage = :file
    config.root = File.join(Rails.root, 'public')
    config.asset_host = ENV['ASSET_HOST']
  end
end
