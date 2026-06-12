module Components
  module Pins
    class Pin::ThumbBase < Components::Base
      include ActionView::RecordIdentifier

      def initialize(pin:)
        @pin = pin

        ActiveStorage::Current.url_options ||= Rails.application.routes.default_url_options
      end

      def view_template(&)
      end

      private

      def container(&)
        div(class: container_classes, &)
      end

      def core_container_classes
        "w-full aspect-square bg-muted flex items-center"
      end

      def container_classes
        core_container_classes + " #{dom_id(@pin, :thumb)}"
      end
    end
  end
end
