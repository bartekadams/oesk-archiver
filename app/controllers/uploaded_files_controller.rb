class UploadedFilesController < ApplicationController

  def index
    @files = UploadedFile.all
  end

  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    file = UploadedFile.new
    file.name = params[:uploaded_file][:file].original_filename
    file.size = params[:uploaded_file][:file].size
    file.file = params[:uploaded_file][:file]
    file.save

    #po save rozpoczecie pakowania w formatach np

    #po spakowaniu zrobienie create wiecej plikow xD
    #original file id? type: pdf, txt, doc itp

    redirect_to uploaded_files_path
  end

  def shell
    path = Rails.root / 'public' / 'uploads' / 'uploaded_file' / 'file'
    files = UploadedFile.all # name size file id
    files.each do |file|

    puts path + file.id.to_s
    # c - create
    # z - gzip
    # j - bzip
    # f - okresla nazwe wyjsciowa pliku
    path_to_file = path + file.id.to_s + file.name

    # TAR archive
    type = '.tar'
    puts `tar -c #{path_to_file.to_s} -f #{path_to_file.to_s + type}`
    File.open(path_to_file.to_s + type) do |f|
      CompressedFile.create(
        name: file.name + type,
        file_type: :tar,
        uploaded_file: file,
        file: f)
    end
    puts `rm #{path_to_file.to_s + type}`

    # TAR.GZ compression
    type = '.tar.gz'
    puts `tar -cz #{path_to_file.to_s} -f #{path_to_file.to_s + type}`
    File.open(path_to_file.to_s + type) do |f|
      CompressedFile.create(
        name: file.name + type,
        file_type: :tar_gz,
        uploaded_file: file,
        file: f)
    end
    puts `rm #{path_to_file.to_s + type}`

    # TAR.BZ compression
    type = '.tar.bz'
    puts `tar -cj #{path_to_file.to_s} -f #{path_to_file.to_s + type}`
    File.open(path_to_file.to_s + type) do |f|
      CompressedFile.create(
        name: file.name + type,
        file_type: :tar_bz,
        uploaded_file: file,
        file: f)
    end
    puts `rm #{path_to_file.to_s + type}`

    #puts `tar -cz #{path_to_file} -f #{path_to_file}.tar.gz`
    #puts `tar -cj #{path_to_file} -f #{path_to_file}.tar.bz`
    #puts `cp #{path + file.id.to_s + file.name} #{path + file.id.to_s + file.name}x`

    end
    #cmd = 'echo "hi"'
    #value = system 'false'
    #puts `pwd` #backticks shell execution style
    #puts $?.to_i #exit status, 0 is good
    #path = Rails.root / 'public' / 'uploads' / 'uploaded_file' / 'file' / '1'
    #puts path #Rails.root / 'public' / 'uploads' / 'uploaded_file' / 'file'
    #puts `ls -al #{path}`
    #puts new_uploaded_file_path
  end

  def clear_all_files
    f = UploadedFile.all.destroy_all
  end
end
