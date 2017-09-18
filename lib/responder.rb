require_relative 'interaction_matcher'

require_relative 'errors/not_found'
require_relative 'errors/unauthorized'
require_relative 'errors/unprocessable_entity'

module Responder
  # rubocop:disable Metrics/AbcSize
  def respond_with(monad, status: 200, **rest)
    InteractionMatcher.call(monad) do |result|
      result.success do |value|
        render(
          { json: value, root: 'data', status: status }.merge(rest)
        )
      end

      result.failure :unauthorized do
        render status: 401,
               json: Errors::Unauthorized.new.to_json
      end

      result.failure :invalid do |value|
        render status: 422,
               json: Errors::UnprocessableEntity.new(value).to_json
      end

      result.failure :not_found do |value|
        render status: 404,
               json: Errors::NotFound.new(value).to_json
      end

      result.failure :forbidden do
        render status: 403,
               json: Errors::Forbidden.new.to_json
      end
    end
  end
end
