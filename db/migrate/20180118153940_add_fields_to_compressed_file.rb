class AddFieldsToCompressedFile < ActiveRecord::Migration[5.1]
  def change
    add_column :compressed_files, :compression_ratio, :float
    add_column :compressed_files, :compression_time, :float
  end
end
