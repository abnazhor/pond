module Components
  module Pins
    class Pin::PrimaryActions < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        # @todo properly distribute action container and title continer. Do not rely on bottom pdding, yuck
        div(class: "absolute bottom-0 left-0 right-0 bottom-0 p-2 pb-10 hidden group-hover:block") do
          div(class: "flex place-content-between w-full") {
            save if authenticated?
            Link(href: @pin.pinable.url_cache&.url, variant: :primary, rel: :nofollow, class: "ml-auto") { "Source ↗" }
          }
        end
      end

      private

      def save
        options_for_select = Current.collections_for_select.map { |p| [ p.name, p.id ] }

        form_with(model: @pin, url: update_collection_pin_path(@pin), class: "max-w-1/2", method: :patch, data: { controller: "auto-submit" }) do |f|
          f.select(:collection_id,
                   options_for_select,
                   {},
                   class: "bg-white p-2 max-w-full text-ellipsis",
                   data: { action: "auto-submit#submit" }
          )
        end
      end
    end
  end
end
