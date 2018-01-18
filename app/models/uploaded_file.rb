class UploadedFile < ApplicationRecord
  enum file_type: [:other]
  has_many :compressed_files, dependent: :destroy
  mount_uploader :file, UploadedFileUploader
end
