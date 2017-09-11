require_relative 'base'

module Errors
  class NotFound < Base
    def initialize(id:, entity:)
      @id = id
      @entity = entity
    end

    private

    attr_reader :id, :entity

    def title
      I18n.t('errors.titles.not_found')
    end

    def message
      I18n.t('errors.messages.not_found', id: id, entity: entity)
    end
  end
end
