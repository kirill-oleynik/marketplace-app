class BaseUploader < CarrierWave::Uploader::Base
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def store_dir
    File.join(store_dir_prefix, root_dir_name, model.id.to_s)
  end

  private

  def secure_token
    var = :"@#{mounted_as}_secure_token"

    model.instance_variable_get(var) ||
      model.instance_variable_set(var, SecureRandom.uuid)
  end

  def root_dir_name
    self.class.name.underscore.gsub(/_uploader$/, '')
  end

  def store_dir_prefix
    if Rails.env.production?
      ''
    else
      File.join('uploads', Rails.env)
    end
  end
end
