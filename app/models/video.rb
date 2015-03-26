class Video < ActiveRecord::Base
  mount_uploader :file, VideoUploader
  after_create :long_process

  def ready!
    self.status = 1
    save
  end

  def process
    movie = FFMPEG::Movie.new tmp_path
    self.quality = ConverterHelper.convertable_quality movie.height
    self.duration = movie.duration
    self.file = File.open tmp_path
    ready!
    system "rm #{tmp_path}"
    self.tmp_path = nil
    save
  end


  def add2mp4box(format, opts)
    file = Rails.root.join("public", self.file.url).to_s
    system  "MP4Box -inter '500' #{file}"
  end

  private
  def long_process
    Delayed::Job.enqueue VideoFileJob.new(id)
  end
end
