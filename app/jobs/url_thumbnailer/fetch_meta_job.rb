class UrlThumbnailer::FetchMetaJob < ApplicationJob
  queue_as :fetch_url_meta

  retry_on Faraday::TooManyRequestsError, wait: :polynomially_longer, attempts: 5

  def perform(post)
    UrlThumbnailer.new(post).call
  end
end
