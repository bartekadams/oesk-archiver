class UploadedFile < ApplicationRecord
  enum file_type: [:other]

  mount_uploader :file, UploadedFileUploader
end
