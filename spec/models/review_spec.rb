require 'rails_helper'

RSpec.describe Review do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:application) }
end
