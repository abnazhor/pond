class FeedsController < ApplicationController
  before_action :authenticate_user!

  def show
    add_breadcrumb("Feed", feed_path)

    @collections = policy_scope(Collection.joins(:user).where(users: { id: current_user.followers.select(:id) }).order(changed_at: :desc).includes(:user).limit(20))

    render Views::Feeds::Index.new(collections: @collections, opts: { show_collection_author: true })
  end
end
