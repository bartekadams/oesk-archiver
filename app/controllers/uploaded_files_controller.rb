class UploadedFilesController < ApplicationController

  def index
    @files = UploadedFile.all
  end

  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    @file = UploadedFile.new
    @file.name = params[:uploaded_file][:file].original_filename
    @file.file = params[:uploaded_file][:file]
    @file.save

    redirect_to uploaded_files_path
  end
end
