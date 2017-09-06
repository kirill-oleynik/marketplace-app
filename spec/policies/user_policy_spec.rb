require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }
  let(:current_user) { attributes_for(:user) }
  let(:other_user) { attributes_for(:user) }

  permissions :update? do
    it 'grants access if current user is requested to be updated' do
      expect(subject).to permit(current_user, current_user)
    end

    it 'denies access if other user is requested to be updated' do
      expect(subject).not_to permit(current_user, other_user)
    end
  end
end
