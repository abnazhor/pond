module Components
  module Posts
    class PinContent::Thumb < Components::Pins::Pin::ThumbBase
      include ActionView::RecordIdentifier

      def view_template(&)
        container do
          image
        end
      end

      private

      def image
        if @pin.pinable.screenshot&.attached?
          img(src: rails_blob_path(@pin.pinable.screenshot.variant(:square_350)), width: 350, loading: :lazy)
        elsif @pin.pinable.url_cache&.thumb&.attached?
          img(src: rails_blob_path(@pin.pinable.url_cache.thumb.variant(:square_350)), width: 350, loading: :lazy)
        end
      end

      # I had to overwrite the default rails helper to be able trender that partial outside of a view context.
      # Is there a better way to do this?
      def rails_blob_path(variant)
        Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
      end
    end
  end
end
