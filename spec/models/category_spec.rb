require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to have_many(:application_categories) }
  it do
    is_expected.to have_many(:applications).through(:application_categories)
  end
end
