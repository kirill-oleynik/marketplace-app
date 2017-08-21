require_relative 'errors/validation'
require_relative 'interaction_matcher'

module Responder
  def respond_with(monad, status: 200, **rest)
    InteractionMatcher.call(monad) do |result|
      result.success do |value|
        render({ json: value, root: 'data', status: status }.merge(rest))
      end

      result.failure :invalid do |value|
        error = Errors::Validation.new(violations: value)
        render json: error, status: 422, root: 'error',
               serializer: ValidationErrorSerializer
      end

      result.failure :unauthorized do |value|
        error = Errors::Authentication.new(violations: value)
        render json: error, status: 401, root: 'error',
               serializer: ValidationErrorSerializer
      end
    end
  end
end
