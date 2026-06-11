module Views
  module Users
    class Header::PrimaryMeta < Components::Base
      include Phlex::Rails::Helpers::Pluralize

      def initialize(user:)
        @user = user
      end

      def view_template
        RubyUI::Text(as: "p", size: "xs", weight: "muted", class: "italic") {
          @user == current_user ? current_user_primary_meta : displayed_user_primary_meta
        }
      end

      def current_user_primary_meta
        items = []

        items << "You have #{pluralize(collections.count, "collection")} with #{pluralize(collections.sum(&:pins_count), "pin")}."
        items << "Your profile is private." if @user.private?

        items.join(" ")
      end

      def displayed_user_primary_meta
        items = []

        items << "#{@user} has #{pluralize(collections.count, "collection")} with #{pluralize(collections.sum(&:pins_count), "pin")}."
        items << "This profile is private." if @user.private?

        items.join(" ")
      end

      def collections
        CollectionPolicy::Scope.new(current_user, @user.collections).resolve
      end
    end
  end
end
