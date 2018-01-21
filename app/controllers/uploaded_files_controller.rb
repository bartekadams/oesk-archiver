class UploadedFilesController < ApplicationController

  def index
    @data = {} # same as Hash.new
    @data[:pdf] = getData(UploadedFile.where(file_type: :pdf))
    @data[:doc] = getData(UploadedFile.where(file_type: :doc))
    @data[:other] = getData(UploadedFile.where(file_type: :other))
  end

  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    file = UploadedFile.new
    file.name = params[:uploaded_file][:file].original_filename.gsub(/\s+/, '_')
    file.size = params[:uploaded_file][:file].size
    file.file = params[:uploaded_file][:file]
    file.file_type = params[:uploaded_file][:file_type].to_i
    file.save

    shell(file)

    redirect_to uploaded_files_path
  end

  def clear_all_files
    f = UploadedFile.all.destroy_all
  end

  private

  def time_diff_milli(start, finish)
    (finish - start) * 1000.0
  end

  def shell(file)
    path = Rails.root / 'public' / 'uploads' / 'uploaded_file' / 'file'
    puts path + file.id.to_s
    path_to_file = path + file.id.to_s + file.name

    # tar achiver for Ubuntu
    # c - create
    # z - gzip
    # j - bzip
    # f - okresla nazwe wyjsciowa pliku

    # TAR archive
=begin
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
=end

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

    # LZ4 High compression
    # Compiled from source: https://github.com/lz4/lz4/tree/master
    type = '.lz4'
    time_start - Time.now
    `lz4 -9 #{path_to_file.to_s} #{path_to_file.to_s + type}`
    time_end = Time.now
    File.open(path_to_file.to_s + type) do |f|
      CompressedFile.create(
      name: file.name + type,
      file_type: :lz4,
      uploaded_file: file,
      file: f,
      compression_ratio: f.size.to_f / file.size.to_f,
      compression_time: time_diff_milli(time_start, time_end))
    end
    `rm #{path_to_file.to_s + type}`

    # xz compression
    # xz-utils: https://packages.ubuntu.com/xenial/xz-utils
    type = '.xz'
    time_start - Time.now
    `xz -zk9 #{path_to_file.to_s}`
    time_end = Time.now
    File.open(path_to_file.to_s + type) do |f|
      CompressedFile.create(
      name: file.name + type,
      file_type: :xz,
      uploaded_file: file,
      file: f,
      compression_ratio: f.size.to_f / file.size.to_f,
      compression_time: time_diff_milli(time_start, time_end))
    end
    `rm #{path_to_file.to_s + type}`

    # 7z LZMA compression
    # p7zip-full: http://manpages.ubuntu.com/manpages/xenial/man1/7z.1.html
    type = '.7z'
    time_start - Time.now
    `7z a -t7z -mx=9 #{path_to_file.to_s + type} #{path_to_file.to_s}`
    time_end = Time.now
    File.open(path_to_file.to_s + type) do |f|
      CompressedFile.create(
      name: file.name + type,
      file_type: :_7z,
      uploaded_file: file,
      file: f,
      compression_ratio: f.size.to_f / file.size.to_f,
      compression_time: time_diff_milli(time_start, time_end))
    end
    `rm #{path_to_file.to_s + type}`

    # KGB Archiver
    # kgb: http://manpages.ubuntu.com/manpages/xenial/man1/kgb.1.html
    type = '.kgb'
    time_start - Time.now
    `kgb -1 #{path_to_file.to_s + type} #{path_to_file.to_s}`
    time_end = Time.now
    File.open(path_to_file.to_s + type) do |f|
      CompressedFile.create(
      name: file.name + type,
      file_type: :kgb,
      uploaded_file: file,
      file: f,
      compression_ratio: f.size.to_f / file.size.to_f,
      compression_time: time_diff_milli(time_start, time_end))
    end
    `rm #{path_to_file.to_s + type}`
  end

  def getData(uploaded_files)
    data = {}
    data[:tar_gz] = []
    data[:tar_bz] = []
    data[:lz4] = []
    data[:xz] = []
    data[:_7z] = []
    data[:kgb] = []

    uploaded_files.each do |file|
      file.compressed_files.each do |compressed|
        file_data = {
            uncompressed_file_size: file.size,
            compressed_file_size: compressed.size,
            compression_ratio: compressed.compression_ratio,
            name: compressed.name,
            compression_time: compressed.compression_time
        }
        case compressed.file_type.to_sym
        when :tar_gz
          data[:tar_gz].push(file_data)
        when :tar_bz
          data[:tar_bz].push(file_data)
        when :lz4
          data[:lz4].push(file_data)
        when :xz
          data[:xz].push(file_data)
        when :_7z
          data[:_7z].push(file_data)
        when :kgb
          data[:kgb].push(file_data)
        end
      end
    end
    data # return data

  end
end
