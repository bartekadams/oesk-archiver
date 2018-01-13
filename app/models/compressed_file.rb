class CompressedFile < ApplicationRecord
  # http://api.rubyonrails.org/v5.1/classes/ActiveRecord/Enum.html
  enum file_type: [:tar_gz, :tar_bz]

  belongs_to :uploaded_file
  mount_uploader :file, CompressedFileUploader
end
