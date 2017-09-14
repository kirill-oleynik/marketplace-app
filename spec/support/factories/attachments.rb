FactoryGirl.define do
  factory :attachment do
    filename { Faker::File.file_name }
    original_filename { Faker::File.file_name }
    size { rand(100..5000) }
    content_type { Faker::File.mime_type }
  end
end
