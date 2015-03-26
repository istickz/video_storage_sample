class Api::V1::VideosController <  Api::V1::BaseController

  # POST api/v1/videos.json
  def create
    @video = Video.new video_params

    if @video.save
      render json: {video_id: @video.id, info: 'Video successfully added'}, status: 200
    else
      render json: @video.errors
    end
  end


  private
  def video_params
    uploaded_file_path = params[:video_file].path

    # Create Symlink for uploaded file
    link_to_file = '/tmp/' + uploaded_file_path.split('/').last.gsub('RackMultipart', 'VideoLink')
    system "ln #{uploaded_file_path} #{link_to_file}"

    # We need only link to tmp_file path
    { tmp_path: link_to_file.to_s }
  end
end