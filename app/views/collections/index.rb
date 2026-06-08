# frozen_string_literal: true

class Views::Collections::Index < Views::Base
  include Phlex::Rails::Helpers::Pluralize

  def initialize(collections:, inbox:, user:)
    @inbox = inbox
    @collections = collections
    @user = user
  end

  def view_template
    div(class: "w-full") do
      render Components::Ui::PageHeader.new do |header|
        header.with_primary do
          RubyUI::Text(as: "p", weight: "", class: "mb-4") { @user.description } if @user.description.present?
          RubyUI::Text(as: "p", size: "xs", weight: "muted", class: "italic") { primary_meta }
        end

        header.with_actions do
          if policy(@user).edit?
            Components::Users::EditBtn(user: @user)
          end
        end
      end

      Separator(class: "my-9")

      render Components::Collections::Collection.new(collection: @inbox) if @inbox

      @collections.each do |collection|
        render Components::Collections::Collection.new(collection: collection)
      end

      if policy(@user).add_collection?
        render Components::Collections::AddBtn.new(collection: Collection.new)
      end
    end
  end

  private

  def primary_meta
    items = []

    items << "You have #{pluralize(@user.collections.count, "collection")} with #{pluralize(@user.collections.sum(&:pins_count), "pin")}."
    items << "Your profile is private." if @user.private?

    items.join(" ")
  end
end
