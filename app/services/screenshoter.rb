class Screenshoter
  SCREEN_WIDTH = 1440
  SCREEN_HEIGHT = 1440

  class ResponseStatusInvalidError < StandardError; end
  class UnsupportedLinkType < StandardError; end

  def initialize(post)
    @post = post
  end

  def call
    if @post.url.match?(%r{https?://(www\.)?instagram\.com/[a-zA-Z._]+})
      raise UnsupportedLinkType, "Instagram profile previews are not supported yet"
    elsif @post.url.match?(%r{https?://(www\.)?youtube\.com/watch\?v=[a-zA-Z0-9_-]+})
      raise UnsupportedLinkType, "YouTube video previews are not supported yet"
    elsif @post.url.match?(%r{https?://.*\.(gif|gifv)(\?.*)?$})
      raise UnsupportedLinkType, "GIF screenshots are not supported, they make no sense"
    else
      Screenshoter::DefaultHandler.new(@post).call
    end

    @post.refresh_pins_cards
  end
end
