class UploadedFile < ApplicationRecord
  mount_uploader :file, UploadedFileUploader
end
