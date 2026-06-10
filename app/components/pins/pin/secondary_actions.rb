module Components
  module Pins
    class Pin::SecondaryActions < Components::Base
      include Phlex::Rails::Helpers::DOMID

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        div(class: "absolute top-2 right-2 hidden group-hover:block") do
          DropdownMenu(options: { placement: "bottom-start" }) do
            DropdownMenuTrigger(class: "w-full") do
              Button(variant: :outline, size: :sm) { "More" }
            end
            DropdownMenuContent do
              DropdownMenuLabel { "Pin options" }
              DropdownMenuSeparator
              DropdownMenuItem(href: pin_path(@pin), data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }) { "Delete" }
            end
          end
        end
      end
    end
  end
end
