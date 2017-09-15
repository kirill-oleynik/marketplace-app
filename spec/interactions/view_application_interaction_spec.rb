require 'rails_helper'

RSpec.describe ViewApplicationInteraction do
  let(:application) { build(:application, slug: 'hello') }
  let(:repository) { double(find_by_slug!: application) }

  subject { ViewApplicationInteraction.new(repository: repository) }

  describe 'when transaction was successful' do
    it 'is returns right monad with application' do
      result = subject.call(application.slug)

      expect(result).to be_right
      expect(result.value).to eq(application)
    end
  end

  describe 'when application not exists' do
    let(:repository) do
      mock = double
      allow(mock).to receive(:find_by_slug!).with(application.slug)
                                            .and_raise(
                                              ActiveRecord::RecordNotFound
                                            )
      mock
    end

    it 'is returns left monad with not found error tuple' do
      result = subject.call(application.slug)

      expect(result).to be_left
      expect(result.value[0]).to eq(:not_found)
      expect(result.value[1]).to eq(id: 'hello', entity: 'application')
    end
  end
end
