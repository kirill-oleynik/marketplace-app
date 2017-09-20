require 'rails_helper'

RSpec.describe GalleryAttachment, type: :model do
  it { is_expected.to belong_to(:gallery) }
  it { is_expected.to belong_to(:attachment) }
end
