class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Based on ActiveRecord::Base.update implementation
  # More info http://bit.ly/2goPSz5
  def self.update!(id = :all, attributes)
    if id.is_a?(Array)
      id.map.with_index { |one_id, idx| update!(one_id, attributes[idx]) }
    elsif id == :all
      records.each { |record| record.update!(attributes) }
    else
      if id.is_a?(ActiveRecord::Base)
        raise ArgumentError, <<-MSG.squish
          You are passing an instance of ActiveRecord::Base to `update!`.
          Please pass the id of the object by calling `.id`.
        MSG
      end
      object = find(id)
      object.update!(attributes)
      object
    end
  end
end
