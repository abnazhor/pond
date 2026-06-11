class Screenshoter
  SCREEN_WIDTH = 1440
  SCREEN_HEIGHT = 1440

  class ResponseStatusInvalidError < StandardError; end

  def initialize(post)
    @post = post
  end

  def call
    if @post.url.match?(%r{https?://(www\.)?instagram\.com/[a-zA-Z._]+})
      raise NotImplementedError, "Instagram profile previews are not supported yet"
    else
      Screenshoter::DefaultHandler.new(@post).call
    end

    @post.refresh_pins_cards
  end
end
