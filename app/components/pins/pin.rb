module Components
  module Pins
    class Pin < Components::Base
      include Phlex::Rails::Helpers::TimeAgoInWords
      include Phlex::Rails::Helpers::OptionsFromCollectionForSelect
      include Phlex::Rails::Helpers::DOMID

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        div(class: "flex flex-col group relative", id: dom_id(@pin)) do
          div(class: "w-full aspect-square bg-muted flex items-center") do
            if @pin.pinable.url_cache&.thumb&.attached?
              img(src: url_for(@pin.pinable.url_cache.thumb.variant(:square_350)), width: 350, loading: :lazy)
            end
          end

          render Components::Pins::Pin::SecondaryActions.new(pin: @pin) if authenticated?
          render Components::Pins::Pin::PrimaryActions.new(pin: @pin) if authenticated?

          div(class: "p-1 py-2") do
            title
            time_and_by
          end
        end
      end

      private

      def title
        span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:hidden") {
          @pin.pinable.url_cache&.title || @pin.pinable.url_cache&.url || "Untitled"
        }
      end

      def time_and_by
        span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:block hidden") {
          "Added #{time_ago_in_words(@pin.created_at)} ago by #{@pin.user}"
        }
      end
    end
  end
end
