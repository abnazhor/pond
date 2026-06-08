module UrlCaches
  class Refresher
    def initialize(url_cache)
      @url_cache = url_cache
    end

    def call
      head_response = Faraday.head(@url_cache.url)
      return unless head_response.success?

      content_type = head_response.headers["content-type"].to_s

      if content_type.start_with?("image/")
        handle_image
      elsif content_type.start_with?("text/")
        handle_html
      else
        raise "Unsupported MIME type: #{content_type}"
      end
    end

    private

    def handle_image
      filename = File.basename(URI.parse(@url_cache.url).path)
      @url_cache.thumb.attach(io: URI.parse(@url_cache.url).open, filename: filename)
      @url_cache.update!(title: filename, refreshed_at: Time.current)
    end

    def handle_html
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
  end
end
