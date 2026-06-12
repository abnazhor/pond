module Components
  module Collections
    class PinContent::Meta < Pins::Pin::MetaBase
      private

      def title
        span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:hidden") {
          @pin.pinable.name
        }
      end
    end
  end
end
