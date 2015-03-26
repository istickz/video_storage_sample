class  ConverterHelper
  # extend ActiveSupport::Concern
  RESOLUTIONS = {
      '1080p' => {resolution: '1920x1080', in: (1080..10000), resizeable_to: ['1920x1080', '1280x720', '640×480', '480×360' '320x240'], watermark: 'channel_logo_1920x1080.png'},
      '720p' => {resolution: '1280x720', in: (720..10000), resizeable_to: ['1280x720', '640×480', '480×360' '320x240'], watermark: 'channel_logo_1280x720.png'},
      '480p' => {resolution: '640×480', in: (480..719), resizeable_to: ['640×480', '480×360' '320x240'], watermark: 'channel_logo_640x480.png'},
      '360p' => {resolution: '480×360', in: (360..479), resizeable_to: ['480×360' '320x240'], watermark: 'channel_logo_480x320.png'},
      '240p' => {resolution: '320x240', in: (1..359), resizeable_to: ['320x240'], watermark: 'channel_logo_320x240.png'}
  }
  ENCODE_PARAMS = {
      watermark: {},
      resolution: :same,
      custom: '-vcodec mpeg4 -acodec libfdk_aac',
      callbacks: {after_transcode: :add2mp4box}
  }

  def self.convertable_params(movie_height)
    RESOLUTIONS.find { |k, v| v[:in].include? movie_height }
  end


  def self.convertable_quality(movie_height)
    convertable_params(movie_height).try :first
  end
end
