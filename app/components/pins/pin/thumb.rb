module Components
  module Pins
    class Pin::Thumb < Components::Base
      def self.new(pin:)
        if pin.pinable_type == "Post"
          Components::Posts::PinContent::Thumb.new(pin: pin)
        elsif pin.pinable_type == "Collection"
          Components::Collections::PinContent::Thumb.new(pin: pin)
        else
          raise "Unknown pinable type: #{pin.pinable_type}"
        end
      end
    end
  end
end
