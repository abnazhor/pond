module Components
  module Posts
    class Form < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def view_template(&)
        form_with(model: Pin.new, id: :post_form) do |f|
          f.hidden_field(:collection_id, value: Current.collection&.id)

          f.fields_for :pinable, Post.new do |pf|
            pf.url_field(:url, placeholder: "Enter URL...", required: true, class: "w-full mb-4 text-xl border py-2 px-3", autocomplete: "off", autofocus: true, data: { ruby_ui__dialog_target: "autofocusable" })
          end
        end
      end
    end
  end
end
