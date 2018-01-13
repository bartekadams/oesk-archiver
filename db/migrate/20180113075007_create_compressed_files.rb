class CreateCompressedFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :compressed_files do |t|
      t.string :name
      t.string :file
      t.integer :size
      t.references :uploaded_file, foreign_key: true

      t.timestamps
    end
  end
end
