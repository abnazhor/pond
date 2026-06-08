module Components
  module Pins
    class Pin < Components::Base
      include Phlex::Rails::Helpers::TimeAgoInWords
      include Phlex::Rails::Helpers::OptionsFromCollectionForSelect
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::DOMID

      def initialize(pin:)
        @pin = pin
      end

      def view_template(&)
        div(href: pin_path(@pin), class: "flex-1 relative group", id: dom_id(@pin)) do
          if @pin.pinable.url_cache&.thumb&.attached?
            img(src: url_for(@pin.pinable.url_cache.thumb.variant(:square_300)), width: 300, height: 300, loading: :lazy)
          else
            div(class: "w-full aspect-square bg-muted")
          end

          secondary_actions_dropdown if authenticated?
          primary_actions

          div(class: "absolute bottom-0 left-0 right-0 bg-white p-1 py-2", title: title) do
            span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:hidden") {
              title
            }

            span(class: "text-xs text-muted-foreground text-nowrap overflow-hidden text-ellipsis max-w-full block text-center group-hover:block hidden") {
              time_and_by
            }
          end
        end
      end

      private

      def title
        @pin.pinable.url_cache&.title || @pin.pinable.url_cache&.url || "Untitled"
      end

      def time_and_by
        "Added #{time_ago_in_words(@pin.created_at)} ago by #{@pin.user}"
      end

      def secondary_actions_dropdown
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

      def primary_actions
        # @todo properly distribute action container and title continer. Do not rely on bottom pdding, yuck
        div(class: "absolute bottom-0 left-0 right-0 bottom-0 p-2 pb-10 hidden group-hover:block") do
          div(class: "flex place-content-between w-full") {
            form_with(model: @pin, url: update_collection_pin_path(@pin), class: "max-w-1/2", method: :patch, data: { controller: "auto-submit" }) do |f|
              f.select(:collection_id, Current.collections_for_select.map { |p| [ p.name, p.id ] }, {}, class: "bg-white p-2 max-w-full text-ellipsis", data: { action: "auto-submit#submit" })
            end if authenticated?

            Link(href: @pin.pinable.url_cache&.url, variant: :primary, rel: :nofollow, class: "ml-auto") { "Source ↗" }
          }
        end
      end
    end
  end
end
