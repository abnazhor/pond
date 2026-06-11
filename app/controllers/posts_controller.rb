class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :create ]
  # before_action :set_pin, only: %i[ show edit update destroy ]

  # GET /pins/new
  def new
    render Views::Posts::New.new
  end

  def pin
    @pin = Pin.new
    @post = Post.find(params[:id])
    authorize @pin, :new?

    render Views::Pins::New.new(pin: @pin, post: @post)
  end

  def create
    @referrer_action = Rails.application.routes.recognize_path(request.referer)

    @post = Post.find_or_initialize_by(url: pin_params[:pinable_attributes][:url])
    @post.url_cache = UrlCache.find_or_create_by(url: @post.url)
    @post.save if @post.new_record?

    @pin = Pin.new
    @pin.pinable = @post
    @pin.user = current_user
    collection = current_user.collections.find_by(id: pin_params[:collection_id]) || current_user.collections.find_inbox!
    @pin.collection = collection

    authorize @pin

    if @pin.save!
      UrlCaches::RefreshJob.perform_later(@post.url_cache) unless @post.url_cache.fresh?
      Posts::GenerateScreenshotJob.perform_later(@post) if Figaro.env.screenshoter_enabled == "true"
      collection.touch(:changed_at)

      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  private

  def pin_params
    params.require(:pin).permit(:collection_id, pinable_attributes: [ :url ])
  end
end
