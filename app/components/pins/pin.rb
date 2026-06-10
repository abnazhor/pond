module Components
  module Pins
    class Pin < Components::Base
      include Phlex::Rails::Helpers::OptionsFromCollectionForSelect
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::TurboStreamFrom

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        div(class: "flex flex-col group relative", id: dom_id(@pin)) do
          turbo_stream_from(@pin, :card)

          render Components::Pins::Pin::Thumb.new(pin: @pin)
          render Components::Pins::Pin::SecondaryActions.new(pin: @pin) if authenticated?
          render Components::Pins::Pin::PrimaryActions.new(pin: @pin)
          render Components::Pins::Pin::Meta.new(pin: @pin)
        end
      end
    end
  end
end
