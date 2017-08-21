class ValidationErrorSerializer < ActiveModel::Serializer
  attributes :title, :violations

  def violations
    object.violations.each_with_object({}) do |(key, messages), accumulator|
      accumulator[key] = messages.map do |message|
        "#{key.to_s.humanize.titleize} #{message}"
      end
    end
  end
end
