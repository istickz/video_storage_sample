class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  storage :file

  process :encode

  # version :p240 do
  #   process :encode => ['240p']
  # end


  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  def cache_dir
    '/tmp/videos'
  end


  private


  def encode(encode_params = ConverterHelper::ENCODE_PARAMS, quality = nil)
    encode_video(:mp4, encode_params) do |movie, params|
      if quality.present?
        q_params = ConverterHelper::RESOLUTIONS[quality]
      else
        quality, q_params = ConverterHelper.convertable_params movie.height
      end

      params[:resolution] = q_params[:resolution]
      params[:watermark][:path] = File.join(Rails.root, 'public', 'watermarks', q_params[:watermark])
      params[:watermark][:position] = :top_right
      params[:watermark][:pixels_from_edge] = 10
    end
  end

end
