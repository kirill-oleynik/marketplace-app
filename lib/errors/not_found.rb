require_relative 'base'

module Errors
  class NotFound < Base
    private

    def title
      I18n.t('errors.titles.not_found')
    end

    def message
      I18n.t('errors.messages.not_found')
    end
  end
end
