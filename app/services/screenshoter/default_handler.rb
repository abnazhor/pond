class Screenshoter::DefaultHandler
  def initialize(post)
    @post = post
  end

  def call
    page = browser.create_page
    page.command("Network.setBlockedURLs",
      urls: [
        "*consent*",
        "*cookie*",
        "*onetrust*",
        "*didomi*"
      ]
    )

    page.go_to(@post.url)
    status = page.network.status
    raise Screenshoter::ResponseStatusInvalidError.new("Invalid response status: #{status}") if status != 200

    page.set_viewport(width: Screenshoter::SCREEN_WIDTH, height: Screenshoter::SCREEN_HEIGHT)
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

  def browser
    @browser ||= Ferrum::Browser.new(
      ws_url: Figaro.env.screenshoter_ws_url,
      pending_connection_errors: false,
    )
  end
end
