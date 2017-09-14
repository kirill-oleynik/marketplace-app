class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :description, :website, :email, :address,
             :phone, :founded

  attribute(:logo) { Faker::Company.logo }
end
