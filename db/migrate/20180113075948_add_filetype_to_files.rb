class AddFiletypeToFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :uploaded_files, :file_type, :integer
    add_column :compressed_files, :file_type, :integer
  end
end
