module Components
  module Collections
    class PinContent::Thumb < Pins::Pin::ThumbBase
      def view_template(&)
        container do
          div do
            Text(size: "2", class: "mt-2") { @pin.pinable.description }
            Components::Collections::MetaInfo(collection: @pin.pinable, opts: { show_author: true })
          end
        end
      end

      private

      def core_container_classes
        super + " p-3"
      end
    end
  end
end
