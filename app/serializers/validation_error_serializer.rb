class ValidationErrorSerializer < ActiveModel::Serializer
  attributes :title, :violations
end
