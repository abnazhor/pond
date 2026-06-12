module Views
  module Pins
    class SecondaryActions < Views::Base
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        turbo_frame_tag(dom_id(@pin, :secondary_actions)) do
          DropdownMenuLabel { "Pin options" }

          if policy(@pin).destroy?
            DropdownMenuSeparator
            DropdownMenuItem(href: pin_path(@pin), data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }) { "Delete" }
          end
        end
      end
    end
  end
end
