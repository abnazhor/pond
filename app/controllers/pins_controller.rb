class PinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pin, only: %i[ update_collection destroy ]
  before_action :preload_user_collections_for_select

  def create
    @post = policy_scope(Post).find(params[:id])
    @referrer_action = Rails.application.routes.recognize_path(request.referer)
    collection = policy_scope(current_user.collections).find(pin_params[:collection_id])
    @pin = Pin.new(collection: collection)
    authorize @pin

    @pin.pinable = @post
    @pin.user = current_user

    if @pin.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @pin
    @pin.destroy!

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "Pin was successfully destroyed." }
      format.turbo_stream
    end
  end

  private

  def set_pin
    @pin = Pin.find(params[:id])
  end

  def pin_params
    params.require(:pin).permit(:collection_id, pinable_attributes: [ :url ])
  end
end
