require 'rails_helper'

RSpec.describe Rating do
  it { is_expected.to belong_to(:application) }
end
