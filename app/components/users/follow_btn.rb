module Components
  module Users
    class FollowBtn < Components::Base
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::DOMID

      def initialize(user:)
        @user = user
      end

      def view_template(&)
        div(id: dom_id(@user, :follow_btn)) do
          if current_user.following?(@user)
            button_to(unfollow_user_path(@user), method: :delete, class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors cursor-pointer disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-3 py-1.5 h-8 text-xs bg-primary text-primary-foreground shadow hover:bg-primary/90") do
              "Unfollow"
            end
          else
            button_to(follow_user_path(@user), method: :post, class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors cursor-pointer disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-3 py-1.5 h-8 text-xs bg-secondary text-secondary-foreground hover:bg-opacity-80") do
              "Follow"
            end
          end
        end
      end
    end
  end
end
