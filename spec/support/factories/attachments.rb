FactoryGirl.define do
  factory :attachment do
    filename { 'hello.png' }
    original_filename { Faker::File.file_name }
    size { rand(100..5000) }
    content_type { Faker::File.mime_type }

    trait :with_file do
      filename do
        path = File.join(Rails.root, 'spec', 'support', 'files', '1.png')
        Rack::Test::UploadedFile.new(path)
      end
    end
  end
end
