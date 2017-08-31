require_relative 'interaction_matcher'

require_relative 'errors/unauthorized'
require_relative 'errors/unprocessable_entity'

module Responder
  def respond_with(monad, status: 200, **rest)
    InteractionMatcher.call(monad) do |result|
      result.success do |value|
        render({ json: value, root: 'data', status: status }.merge(rest))
      end

      result.failure :unauthorized do
        render status: 401,
               json: Errors::Unauthorized.new.to_json
      end

      result.failure :invalid do |value|
        render status: 422,
               json: Errors::UnprocessableEntity.new(value).to_json
      end
    end
  end
end
