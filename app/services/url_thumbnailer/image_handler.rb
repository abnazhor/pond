class UrlThumbnailer::ImageHandler < UrlThumbnailer::DefaultHandler
  def self.match?(post:, preflight:)
    preflight.headers["content-type"].to_s.start_with?("image/")
  end

  def self.screenshotable?(post)
    false
  end

  def process_meta
    logger.info "Processing metadata for URL: #{@post.url}..."

    filename = File.basename(URI.parse(@url_cache.url).path)
    @url_cache.thumb.attach(io: URI.parse(@url_cache.url).open, filename: filename)
    @url_cache.update!(title: filename, refreshed_at: Time.current)
  end

  def process_screenshot
    raise NotImplementedError
  end
end
