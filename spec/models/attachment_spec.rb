require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { is_expected.to have_one(:application) }
end
