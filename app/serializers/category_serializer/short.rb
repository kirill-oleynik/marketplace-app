module CategorySerializer
  class Short < Base
    def applications
      object.applications.take(4)
    end
  end
end
