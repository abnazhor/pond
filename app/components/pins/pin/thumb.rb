module Components
  module Pins
    class Pin::Thumb < Components::Base
      include ActionView::RecordIdentifier

      def initialize(pin:)
        @pin = pin

        ActiveStorage::Current.url_options ||= Rails.application.routes.default_url_options
      end

      def view_template(&)
        div(class: "w-full aspect-square bg-muted flex items-center #{dom_id(@pin, :thumb)}") do
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
