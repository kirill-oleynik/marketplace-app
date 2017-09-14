require 'rails_helper'

RSpec.describe ViewCategoriesListInteraction do
  let(:category) { build(:category) }
  let(:repository) { double(all_with_applications: [category]) }

  subject { ViewCategoriesListInteraction.new(repository: repository) }

  describe 'when transaction was successful' do
    it 'is returns right monad with all categories' do
      result = subject.call

      expect(result).to be_right
      expect(result.value).to eq([category])
    end
  end
end
