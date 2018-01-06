class CreateUploadedFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :uploaded_files do |t|
      t.string :name
      t.string :file

      t.timestamps
    end
  end
end
