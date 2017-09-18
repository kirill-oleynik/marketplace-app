module Support
  module Helpers
    module Mocks
      def repository_mock(name = 'repository')
        mock = double(name)
        yield mock if block_given?
        mock
      end
    end
  end
end
