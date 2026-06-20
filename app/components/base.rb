# frozen_string_literal: true

class Components::Base < Phlex::HTML
  include RubyUI
  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes

  register_value_helper :current_user
  register_value_helper :authenticated?
  register_value_helper :policy
  register_value_helper :marksmithed

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end

  private

  def timeago(date, format: :long)
    return if date.blank?

    content = I18n.l(date, format: format)

    time(
      title: content,
      data: {
        controller: "timeago",
        timeago_datetime_value: date.iso8601
      }
    ) { content }
  end

  def cdn_image_url(model)
    host = ENV["CDN_HOST"] || ENV["HOST"] || "localhost:3000"
    helpers = Rails.application.routes.url_helpers

    if model.respond_to?(:signed_id)
      helpers.rails_blob_url(model, host: host)
    else
      helpers.rails_representation_url(model, host: host)
    end
  end

  def cache_store
    Rails.cache
  end
end
