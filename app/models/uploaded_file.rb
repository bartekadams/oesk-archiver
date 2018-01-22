class UploadedFile < ApplicationRecord
  enum file_type: [:pdf, :doc, :other]
  has_many :compressed_files, dependent: :destroy
  mount_uploader :file, UploadedFileUploader

  validates :file, presence: true
end
