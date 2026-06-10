# frozen_string_literal: true

class Views::Pins::New < Views::Base
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::OptionsFromCollectionForSelect

  def initialize(pin:, post:)
    @pin = pin
    @post = post
  end

  def view_template
    turbo_frame_tag("pin_post") do
      form_with(model: @pin, url: pin_post_path(@post), method: :post, id: :new_pin_form) do |f|
        f.select :collection_id, {}, { include_blank: "Pick one of your collections" }, class: "border-border bg-transparent text-sm w-full min-w-0 appearance-none rounded-md border py-1 pr-8 pl-2.5 shadow-xs transition-[color,box-shadow] outline-none select-none ring-0 ring-ring/0 placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground focus-visible:outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-2 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:ring-destructive/20 aria-invalid:border-destructive aria-invalid:ring-2 h-9" do
          options_from_collection_for_select(current_user.collections, :id, :name)
        end
      end
    end
  end
end
