module CategorySerializer
  class Short < Base
    def applications
      applications_data.first(4)
    end
  end
end
