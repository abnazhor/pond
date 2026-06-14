class UrlThumbnailer::DefaultHandler
  SCREEN_WIDTH = 1440
  SCREEN_HEIGHT = 1440

  class ResponseStatusInvalidError < StandardError; end

  def initialize(post:, preflight:, logger: Rails.logger)
    @post = post
    @preflight = preflight
    @url_cache = @post.url_cache
    @logger = logger
  end

  def self.match?(post:, preflight:)
    preflight.headers["content-type"].to_s.start_with?("text/html")
  end

  def self.screenshotable?(post)
    true
  end

  def process_meta
    logger.info "Processing metadata for URL: #{@post.url}..."

    object = LinkThumbnailer.generate(@url_cache.url)
    @url_cache.update(
      title: object.title,
      description: object.description,
      refreshed_at: Time.current
    )

    return unless object.images.any?

    downloaded_image = URI.parse(object.images.first.src).open

    @url_cache.thumb.attach(
      io: downloaded_image,
      filename: File.basename(URI.parse(object.images.first.src).path)
    )

    @url_cache.touch(:refreshed_at)
  end

  def process_screenshot
    logger.info "Processing screenshot for URL: #{@post.url}..."

    page = browser.create_page

    page.go_to(@post.url)
    status = page.network.status
    raise ResponseStatusInvalidError.new("Invalid response status: #{status}") if status != 200

    page.set_viewport(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    sleep 2

    file = Tempfile.new([ "screenshot", ".png" ])
    page.screenshot(path: file.path)

    @post.screenshot.attach(
      io: File.open(file.path),
      filename: "screenshot.png",
      content_type: "image/png"
    )
  end

  private

  attr_reader :logger

  def browser
    @browser ||= Ferrum::Browser.new(
      ws_url: Figaro.env.screenshoter_ws_url,
      pending_connection_errors: false,
      timeout: 240
    )
  end
end
