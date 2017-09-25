class ApplicationCandidateSerializer < ActiveModel::Serializer
  attributes :id, :url, :description, :user_first_name,
             :user_last_name, :user_email
end
