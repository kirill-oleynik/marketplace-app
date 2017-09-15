class BaseUploader < CarrierWave::Uploader::Base
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def store_dir
    common = File.join(root_dir_name, model.id.to_s)

    if Rails.env.production?
      common
    else
      File.join('uploads', Rails.env, common)
    end
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
end
