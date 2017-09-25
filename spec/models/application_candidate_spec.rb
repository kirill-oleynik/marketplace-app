require 'rails_helper'

RSpec.describe ApplicationCandidate do
  it { is_expected.to belong_to(:user) }
end
