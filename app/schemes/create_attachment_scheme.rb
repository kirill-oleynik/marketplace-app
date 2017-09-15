CreateAttachmentScheme = Dry::Validation.Schema do
  required(:file).value(:file?)
end
