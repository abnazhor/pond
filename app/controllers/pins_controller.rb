class PinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pin, only: %i[ update_collection destroy ]
  before_action :preload_user_collections_for_select

  def create
    @pin = Pin.new(pin_params.except(:pinable_attributes, :collection_id))
    authorize @pin

    @pin.user = current_user
    @pin.collection = current_user.collections.find_by(id: pin_params[:collection_id]) || current_user.collections.find_inbox!
    @pin.pinable = Post.new(pin_params[:pinable_attributes] || {})
    @pin.pinable.url_cache = UrlCache.find_or_create_by(url: @pin.pinable.url)

    if @pin.save
      UrlCaches::RefreshJob.perform_later(@pin.pinable.url_cache)

      redirect_to @pin, notice: "Pin was successfully created."
    else
      render :create, status: :unprocessable_entity
    end
  end

  # @todo validate if given collection id belongs to current user
  def update_collection
    authorize @pin

    @referrer_action = Rails.application.routes.recognize_path(request.referer)
    @old_collection = @pin.collection

    # Validate if target collection belongs to current user
    current_user.collections.find_by!(id: pin_params[:collection_id])

    if @pin.update(pin_params.merge(created_at: Time.current))
      render :update_collection, status: :ok
    else
      render :update_collection, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @pin
    @pin.destroy!

    redirect_back fallback_location: root_path, notice: "Pin was successfully destroyed."
  end

  private

  def set_pin
    @pin = Pin.find(params[:id])
  end

  def pin_params
    params.require(:pin).permit(:collection_id, pinable_attributes: [ :url ])
  end
end
