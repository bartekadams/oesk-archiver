class UploadedFilesController < ApplicationController
  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    #puts params[:uploaded_file].inspect
    puts "haha"
    puts params[:uploaded_file][:file].inspect
    puts params[:uploaded_file][:file].original_filename
    #puts params[:uploaded_file][:file]

    @file = UploadedFile.new
    @file.name = params[:uploaded_file][:file].original_filename
    @file.file = params[:uploaded_file][:file]
    @file.save

    redirect_to new_uploaded_file_path
  end
end
