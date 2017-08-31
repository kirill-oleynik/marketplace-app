class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :phone, :job_title, :organization
end
