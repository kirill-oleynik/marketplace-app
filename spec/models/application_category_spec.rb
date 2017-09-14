require 'rails_helper'

RSpec.describe ApplicationCategory, type: :model do
  it { is_expected.to belong_to(:application) }
  it { is_expected.to belong_to(:category) }
end
