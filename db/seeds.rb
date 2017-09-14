[
  'Research', 'Trade Execution', 'Portfolio Management', 'Data Management',
  'Risk Management', 'Cash Management', 'Securities Pricing',
  'Trade Reconciliation', 'Investor Relations', 'Accounting', 'Compliance',
  'Administration', 'IT Support'
].each { |category| Category.where(title: category).first_or_create! }

50.times do
  Application.where(
    slug: Faker::Internet.slug,
    title: Faker::App.name,
    summary: Faker::Lorem.paragraph,
    description: Faker::Lorem.paragraph,
    website: Faker::Internet.domain_name,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone,
    founded: Faker::Date.between(5.years.ago, Date.yesterday),
    address: Faker::Address.street_address,
    attachment_id: Attachment.where(
      filename: Faker::File.file_name,
      original_filename: Faker::File.file_name,
      size: rand(100..5000),
      content_type: Faker::File.mime_type
    ).first_or_create!.id
  ).first_or_create!
end

Application.find_each do |application|
  ApplicationCategory.where(
    application: application,
    category: Category.order('RANDOM()').first
  ).first_or_create!
end
