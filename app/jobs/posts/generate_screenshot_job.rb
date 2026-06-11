module Posts
  class GenerateScreenshotJob < ApplicationJob
    queue_as :default

    def perform(post)
      Screenshoter.new(post).call
    end
  end
end
