require 'rails_helper'

RSpec.describe ViewCategoryInteraction do
  let(:category) { build(:category, id: 1) }
  let(:repository) { double(find: category) }

  subject { ViewCategoryInteraction.new(repository: repository) }

  describe 'when transaction was successful' do
    it 'is returns right monad with category' do
      result = subject.call(category.id)

      expect(result).to be_right
      expect(result.value).to eq(category)
    end
  end

  describe 'when category not exists' do
    let(:repository) do
      mock = double
      allow(mock).to receive(:find).with(category.id)
                                   .and_raise(ActiveRecord::RecordNotFound)
      mock
    end

    it 'is returns left monad with not found error tuple' do
      result = subject.call(category.id)

      expect(result).to be_left
      expect(result.value[0]).to eq(:not_found)
      expect(result.value[1]).to eq(id: 1, entity: 'category')
    end
  end
end
