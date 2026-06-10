module Components
  module Collections
    class Collection < Components::Base
      include Phlex::Rails::Helpers::Pluralize
      include Phlex::Rails::Helpers::TimeAgoInWords
      include Phlex::Rails::Helpers::DOMID

      def initialize(collection:, id: nil)
        @id = id
        @collection = collection
        @presented_collection = CollectionPresenter.new(@collection)
      end

      def view_template(&)
        div(class: "mb-6", id: @id || dom_id(@collection)) do
          div(class: "grid grid-cols-12 gap-6") do
            div(class: "col-span-3") do
              a(href: href, class: "hover:underline") do
                render RubyUI::Heading(level: 4, class: "inline") { @presented_collection.name }
              end

              span(class: "text-muted-foreground font-normal ml-1 text-sm italic", title: "Private") {
                "(p)"
              } if @collection.private

              Text(size: "2", class: "mt-2") do
                @presented_collection.description
              end

              Text(size: "1", class: "text-muted-foreground mt-2 italic") do
                meta_info
              end
            end

            div(class: "col-span-9 flex gap-6") do
              div(class: "grid grid-cols-12 gap-9") do
                @collection.pins.newest_first.includes(:user, pinable: [ url_cache: :thumb_attachment ]).limit(4).each do |pin|
                  div(class: "col-span-3") do
                    render Components::Pins::Pin(pin: pin)
                  end
                end
              end
            end
          end

          Separator(class: "mt-6 mb-9")
        end
      end

      private

      def href
        user_collection_path(@collection.user, @collection)
      end

      def meta_info
        return nil if @collection.inbox?

        info = []

        info << "private" if @collection.private
        info << "started #{time_ago_in_words(@collection.created_at)} ago"
        info << "updated #{time_ago_in_words(@collection.changed_at)} ago" if @collection.changed_at
        info << "containing #{pluralize(@collection.pins_count, "pin")}"

        info.to_sentence
      end
    end
  end
end
