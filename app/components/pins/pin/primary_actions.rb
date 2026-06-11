module Components
  module Pins
    class Pin::PrimaryActions < Components::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::DOMID

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
        Dialog(id: dom_id(@pin.pinable, :pin_dialog)) do
          DialogTrigger do
            Button { "Connect" }
          end
          DialogContent do
            DialogHeader do
              DialogTitle { "Connect this post" }
              DialogDescription { "Choose a collection to connect this post to." }
            end
            DialogMiddle do
              turbo_frame_tag "pin_post", src: pin_post_path(@pin.pinable), loading: :lazy do
                "Loading..."
              end
            end
            DialogFooter do
              Button(variant: :outline, data: { action: "click->dialog#close" }) { "Cancel" }
              Button(form: "new_pin_form", type: :submit) { "Save" }
            end
          end
        end
      end
    end
  end
end
