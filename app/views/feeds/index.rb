module Views
  module Feeds
    class Index < Views::Base
      def initialize(collections: nil, opts: {})
        @collections = collections
        @opts = opts
      end

      def view_template(&)
        div(class: "w-full") do
          render Components::Ui::PageHeader.new do |header|
            header.with_primary do
              RubyUI::Text(as: "p", weight: "") { "Collections from people you follow" }
            end

            header.with_secondary do
              # RubyUI::Text(as: "p", size: "xs", weight: "muted", class: "italic") {
              #   "Pinned in <a href='#'>Lorem ipsum dolor sit amet</a>, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".html_safe
              # }
            end
          end

          render RubyUI::Separator.new(class: "my-9")

          if @collections.any?
            @collections.each do |collection|
              render Components::Collections::Collection.new(collection: collection, opts: { show_author: @opts[:show_collection_author] })
            end
          else
            p { "No collections to show. Follow some users to see their collections here!" }
          end
        end
      end
    end
  end
end
