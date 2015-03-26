VideoFileJob = Struct.new(:video_id) do
  def perform
    Video.find(video_id).process
  end


  def before(job)
    @start_at = Time.now
    Delayed::Worker.logger.info  "Video converting started. #{@start_at}"
  end


  def success(job)
    Delayed::Worker.logger.info  "Video successfully converted. Converting time: #{Time.now - @start_at}"
  end


  def error(job, exception)
    Delayed::Worker.logger.debug  "Converting failed! #{Time.now}: #{exception}"
  end
end