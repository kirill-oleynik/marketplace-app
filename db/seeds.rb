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

Application.find_each do |application|
  ApplicationCategory.where(
    application: application,
    category_id: Category.ids.sample
  ).first_or_create!

  next if Gallery.find_by(application_id: application.id)
  gallery = Gallery.create!(application: application)

  [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Dubai_aerial_view_-_Unsplash.jpeg/1024px-Dubai_aerial_view_-_Unsplash.jpeg',
    'http://000ehd7.myregisteredwp.com/wp-content/uploads/sites/2076/2016/04/Photo-by-Mike-Petrucci-Unsplash-1024x768.jpg',
    'http://000ehd7.myregisteredwp.com/wp-content/uploads/sites/2076/2016/04/Photo-by-Glen-Carrie-Unsplash-1024x768.jpg',
    'https://s3.amazonaws.com/s3.imagefinder.co/uploads/2016/02/09103702/unsplash-com-photo-1453989799106-bbad8d7b5191-1024x768.jpg',
    'https://s3.amazonaws.com/s3.imagefinder.co/uploads/2016/01/26113547/unsplash-com-photo-1452924872281-04696e001ea3-1024x768.jpg',
    'https://i.imgur.com/Kf2zBCBh.jpg',
    'https://s3.amazonaws.com/s3.imagefinder.co/uploads/2015/12/29041550/unsplash-com-photo-1415226581130-91cb7f52f078-1024x768.jpg',
    'http://www.industrialvalvenews.com/wp-content/uploads/2017/07/michael-hirsch-1962-1024x768.jpg',
    'https://cdn.theculturetrip.com/wp-content/uploads/2017/03/rsz_shanna-camilleri-190745-1024x768.jpg',
    'https://cdn.theculturetrip.com/wp-content/uploads/2017/07/bar-872161_1920-1-1024x768.jpg',
    'https://picalls.com/wp-content/themes/picalls/timthumb.php?src=http://picalls.com/wp-content/uploads/2016/05/Silhouettes-of-palm-trees.jpg&w=1024&h=768&zc=1',
    'http://georgiakayeblog.com/wp-content/uploads/2016/10/photo-1445620466293-d6316372ab59-1024x768.jpg'
  ].each do |url|
    attachment = create_attachment(url)

    GalleryAttachment.create!(
      gallery: gallery,
      attachment: attachment,
      description: Faker::Hipster.paragraph
    )
  end
end
