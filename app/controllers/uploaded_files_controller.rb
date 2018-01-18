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
    files = UploadedFile.all
    files.each do |file|
      puts path + file.id.to_s
      # c - create
      # z - gzip
      # j - bzip
      # f - okresla nazwe wyjsciowa pliku
      path_to_file = path + file.id.to_s + file.name

      # TAR archive
      type = '.tar'
      time_start = Time.now
      `tar -c #{path_to_file.to_s} -f #{path_to_file.to_s + type}`
      time_end = Time.now
      File.open(path_to_file.to_s + type) do |f|
        CompressedFile.create(
          name: file.name + type,
          file_type: :tar,
          uploaded_file: file,
          file: f,
          compression_ratio: f.size.to_f / file.size.to_f,
          compression_time: time_diff_milli(time_start, time_end))
      end
      `rm #{path_to_file.to_s + type}`

      # TAR.GZ compression
      type = '.tar.gz'
      time_start = Time.now
      `tar -cz #{path_to_file.to_s} -f #{path_to_file.to_s + type}`
      time_end = Time.now
      File.open(path_to_file.to_s + type) do |f|
        CompressedFile.create(
          name: file.name + type,
          file_type: :tar_gz,
          uploaded_file: file,
          file: f,
          compression_ratio: f.size.to_f / file.size.to_f,
          compression_time: time_diff_milli(time_start, time_end))
      end
      `rm #{path_to_file.to_s + type}`

      # TAR.BZ compression
      type = '.tar.bz'
      time_start = Time.now
      `tar -cj #{path_to_file.to_s} -f #{path_to_file.to_s + type}`
      time_end = Time.now
      File.open(path_to_file.to_s + type) do |f|
        CompressedFile.create(
          name: file.name + type,
          file_type: :tar_bz,
          uploaded_file: file,
          file: f,
          compression_ratio: f.size.to_f / file.size.to_f,
          compression_time: time_diff_milli(time_start, time_end))
      end
      `rm #{path_to_file.to_s + type}`
    end
  end

  def clear_all_files
    f = UploadedFile.all.destroy_all
  end

  private

  def time_diff_milli(start, finish)
    (finish - start) * 1000.0
  end
end
