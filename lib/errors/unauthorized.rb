require_relative 'base'

module Errors
  class Unauthorized < Base
    private

    def title
      I18n.t('errors.titles.unauthorized')
    end

    def message
      I18n.t('errors.messages.unauthorized')
    end
  end
end
