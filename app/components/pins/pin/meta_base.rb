module Components
  module Pins
    class Pin::MetaBase < Components::Base
      include Phlex::Rails::Helpers::TimeAgoInWords
      include ActionView::RecordIdentifier

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        div(class: "p-1 py-2 #{dom_id(@pin, :meta)}") do
          title
          time_and_by
        end
      end

      private

      def time_and_by
        span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:block hidden") {
          span { "Added " }
          span { timeago(@pin.created_at) }
          span { " ago by #{@pin.user}" }
        }
      end
    end
  end
end
