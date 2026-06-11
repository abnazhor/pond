# frozen_string_literal: true

class Views::Collections::Show < Views::Base
  include Phlex::Rails::Helpers::TimeAgoInWords
  include Phlex::Rails::Helpers::Pluralize
  include Phlex::Rails::Helpers::DOMID

  def initialize(collection:)
    @collection = collection
  end

  def view_template
    div(class: "w-full") do
      render Components::Ui::PageHeader.new do |header|
        header.with_primary do
          RubyUI::Text(as: "p", weight: "") { @collection.description }
          RubyUI::Text(as: "p", size: "xs", weight: "muted", class: "mt-4 italic") { meta_info }
        end

        header.with_secondary do
          # RubyUI::Text(as: "p", size: "xs", weight: "muted", class: "italic") {
          #   "Pinned in <a href='#'>Lorem ipsum dolor sit amet</a>, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".html_safe
          # }
        end

        header.with_actions do
          if policy(@collection).update?
            Components::Collections::EditBtn(collection: @collection)
          end
        end
      end

      render RubyUI::Separator.new(class: "my-9")

      div(class: "grid grid-cols-12 gap-9", id: "inbox-pins") do
        @collection.pins.order(id: :desc).includes(:user, pinable: [ :screenshot_attachment, url_cache: :thumb_attachment ]).each do |pin|
          div(class: "col-span-3", id: dom_id(pin, :cell)) do
            render Components::Pins::Pin.new(pin: pin)
          end
        end
      end
    end
  end

  private

  def meta_info
    info = []

    info << "private" if @collection.private
    info << "started #{time_ago_in_words(@collection.created_at)} ago"
    info << "updated #{time_ago_in_words(@collection.updated_at)} ago"
    info << "containing #{pluralize(@collection.pins_count, "pin")}"

    info.to_sentence
  end
end
