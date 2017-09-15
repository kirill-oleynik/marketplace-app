require 'rails_helper'

RSpec.describe Application, type: :model do
  it { is_expected.to have_many(:application_categories) }
  it { is_expected.to have_many(:categories).through(:application_categories) }
  it { is_expected.to have_one(:application_attachment) }
  it { is_expected.to have_one(:attachment).through(:application_attachment) }
end
