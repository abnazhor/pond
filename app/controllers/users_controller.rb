class UsersController < ApplicationController
  def update
    @user = find_user
    authorize @user

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profile updated successfully."
    else
      render Views::Users::Form.new(user: @user), status: :unprocessable_entity
    end
  end

  def follow
    @user = find_user
    authorize @user, :follow?

    Users::Follower.new(actor: current_user, target: @user).call

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: user_path(@user), notice: "You are now following #{@user.name}." }
    end
  end

  def unfollow
    @user = find_user
    authorize @user, :unfollow?

    Users::Unfollower.new(actor: current_user, target: @user).call

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: user_path(@user), notice: "You have unfollowed #{@user.name}." }
    end
  end

  private

  def find_user
    @find_user ||= User.find_by_username!(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :description, :private)
  end
end
