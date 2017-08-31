class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :phone, :job_title, :organization
end
