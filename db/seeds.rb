require 'open-uri'
require 'faker'

def generate_address
  [
    Faker::Address.street_address,
    "#{Faker::Address.postcode} #{Faker::Address.city}",
    Faker::Address.country
  ].join(', ')
end

def generate_logo(name)
  set = [1, 2, 3, 4].sample

  "https://robohash.org/#{name}?size=300x300&set=set#{set}"
end

def save_tmp_file(local_file_path, remote_file_path)
  File.open(local_file_path, 'wb') do |saved_file|
    open(remote_file_path, 'rb') do |read_file|
      saved_file.write(read_file.read)
    end
  end

  File.open(local_file_path)
end

def create_attachment(remote_file_path)
  path = URI(remote_file_path).path
  filename = File.basename(path)
  tmp_file_path = File.join(Rails.root, 'tmp', filename)

  file = save_tmp_file(tmp_file_path, remote_file_path)
  result = CreateApplicationAttachmentInteraction.new.call(file: file)

  File.unlink(file.path)

  result.value
end

[
  'Research', 'Trade Execution', 'Portfolio Management', 'Data Management',
  'Risk Management', 'Cash Management', 'Securities Pricing',
  'Trade Reconciliation', 'Investor Relations', 'Accounting', 'Compliance',
  'Administration', 'IT Support'
].each do |category|
  next if Category.find_by(title: category)

  Category.create!(title: category, summary: Faker::Lorem.paragraph(4))
end

[
  {
    title: 'Flowdesk',
    slug: 'flowdesk',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    address: generate_address,
    phone: Faker::Number.number(10),
    founded: Faker::Date.between(5.years.ago, Date.today),
    logo: generate_logo('reiciendisdoloresdeserunt.png')
  },
  {
    title: 'Otcom',
    slug: 'otcom',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    phone: Faker::Number.number(10),
    founded: Faker::Date.between(5.years.ago, Date.today),
    logo: generate_logo('oditsuscipitnon.png')
  },
  {
    title: 'Bitwolf',
    slug: 'bitwolf',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    address: generate_address,
    founded: Faker::Date.between(5.years.ago, Date.today),
    logo: generate_logo('aperiamvoluptatemmaxime.png')
  },
  {
    title: 'Voltsillam',
    slug: 'voltsillam',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    address: generate_address,
    phone: Faker::Number.number(10),
    logo: generate_logo('nemoipsamconsequuntur.png')
  },
  {
    title: 'Regrant',
    slug: 'regrant',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    address: generate_address,
    logo: generate_logo('voluptatesevenietut.png')
  },
  {
    title: 'Daltfresh',
    slug: 'daltfresh',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    founded: Faker::Date.between(5.years.ago, Date.today),
    logo: generate_logo('eostenetursuscipit.png')
  },
  {
    title: 'Konklux',
    slug: 'konklux',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    logo: generate_logo('rationequibusdamquis.png')
  },
  {
    title: 'Ventosanzap',
    slug: 'ventosanzap',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    address: generate_address,
    phone: Faker::Number.number(10),
    founded: Faker::Date.between(5.years.ago, Date.today),
    logo: generate_logo('sedautdolores.png')
  },
  {
    title: 'Viva',
    slug: 'viva',
    summary: Faker::Hipster.sentence,
    description: Faker::Lorem.paragraph(4),
    website: Faker::Internet.url,
    email: Faker::Internet.safe_email,
    address: generate_address,
    phone: Faker::Number.number(10),
    founded: Faker::Date.between(5.years.ago, Date.today),
    logo: generate_logo('teneturquamdoloremque.png')
  }
].map do |application_attributes|
  next if Application.find_by(slug: application_attributes[:slug])

  attachment = create_attachment(application_attributes[:logo])

  CreateApplicationInteraction.new.call(
    application_attributes.except(:logo).merge(attachment_id: attachment.id)
  )
end

Category.find_each do |category|
  Application.find_each do |application|
    ApplicationCategory.where(
      category: category,
      application: application
    ).first_or_create!
  end
end
