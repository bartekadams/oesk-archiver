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

    redirect_to uploaded_files_path
  end

  def shell
    path = Rails.root / 'public' / 'uploads' / 'uploaded_file' / 'file'
    files = UploadedFile.all # name size file id
    files.each do |file|

    puts path + file.id.to_s
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
end