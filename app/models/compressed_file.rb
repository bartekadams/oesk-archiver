class CompressedFile < ApplicationRecord
  # http://api.rubyonrails.org/v5.1/classes/ActiveRecord/Enum.html
  enum file_type: [:tar, :tar_gz, :tar_bz, :lz4, :xz, :_7z, :kgb]

  belongs_to :uploaded_file
  mount_uploader :file, CompressedFileUploader

  before_save :set_uploaded_file_size

  private

  def set_uploaded_file_size
    self.size = file.file.size
  end
end
