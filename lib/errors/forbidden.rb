require_relative 'base'

module Errors
  class Forbidden < Base
    private

    def title
      I18n.t('errors.titles.forbidden')
    end

    def message
      I18n.t('errors.messages.forbidden')
    end
  end
end
