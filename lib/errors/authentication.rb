module Errors
  class Authentication < Dry::Struct
    constructor_type :schema

    attribute :title,
              Types::String.default(I18n.t('errors.titles.authentication'))
    attribute :violations, Types::Hash

    alias read_attribute_for_serialization send
  end
end
