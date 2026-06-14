class UrlThumbnailer::FetchMetaJob < ApplicationJob
  queue_as :fetch_url_meta

  def perform(post)
    UrlThumbnailer.new(post).call
  end
end
