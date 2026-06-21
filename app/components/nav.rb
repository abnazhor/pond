module Components
  class Nav < Components::Base
    include Phlex::Rails::Helpers::LinkTo

    def view_template(&)
      div(class: "fixed top-0 left-0 right-0 z-10") do
        nav(class: "flex items-center gap-2 p-3 px-5 container mx-auto bg-white place-content-between") do
          Link(href: root_path, variant: :link, class: "italic px-0 mr-3") do
            "● pond"
          end

          div(class: "flex gap-3 items-center") do
            if authenticated?
              DropdownMenu(options: { placement: "bottom-end" }) do
                DropdownMenuTrigger(class: "w-full") do
                  Button(variant: :link) { current_user.to_param }
                end

                DropdownMenuContent do
                  DropdownMenuLabel { "My Account" }
                  DropdownMenuItem(href: user_path(current_user.to_param)) { "Profile" }
                  DropdownMenuSeparator
                  DropdownMenuItem(href: sign_out_path, data: { turbo_method: :delete }) { "Sign-out" }
                end
              end
            else
              Link(href: join_path, variant: :link) { "Join" }
            end

            render Components::AddPostBtn.new
          end
        end
      end
    end
  end
end
