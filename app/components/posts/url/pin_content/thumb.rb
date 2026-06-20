module Components
  module Posts
    module Url
      class PinContent::Thumb < Components::Pins::Pin::ThumbBase
        include ActionView::RecordIdentifier

        def view_template(&)
          container do
            if image?
              image
            else
              div do
                marksmithed(@pin.post.content).html_safe
              end
            end
          end
        end

        private

        def image
          if @pin.options.thumb_source == "screenshot"
            if @pin.pinable.screenshot.attached?
              screenshot_image
            elsif @pin.pinable.url_cache.thumb.attached?
              thumb_image
            end
          else
            if @pin.pinable.url_cache.thumb.attached?
              thumb_image
            elsif @pin.pinable.screenshot.attached?
              screenshot_image
            end
          end
        end

        def rails_blob_path(variant)
          Rails.application.routes.url_helpers.rails_representation_path(variant, only_path: true)
        end

        def screenshot_image
          img(src: cdn_image_url(@pin.pinable.screenshot.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
        end

        def thumb_image
          img(src: cdn_image_url(@pin.pinable.url_cache.thumb.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
        end

        def image?
          @pin.pinable.content.blank?
        end

        def core_container_classes
          if image?
            super
          else
            super + " p-3"
          end
        end
      end
    end
  end
end
