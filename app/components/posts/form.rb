module Components
  module Posts
    class Form < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize(pin: Pin.new)
        @pin = pin
      end

      def view_template(&)
        form_with(model: @pin, url: posts_path, id: :post_form) do |f|
          f.hidden_field(:collection_id, value: Current.collection&.id)

          f.fields_for :pinable, Post.new do |pf|
            pf.url_field(:url, placeholder: "Enter URL...", required: true, class: "w-full mb-2 text-xl border py-2 px-3", autocomplete: "off", autofocus: true, data: { add_pin_dialog_target: "urlInput" })
            Text(size: "1", class: "text-muted-foreground") { "TIP: Paste a URL anywhere on PPP to quickly add a pin." }
          end
        end
      end
    end
  end
end
