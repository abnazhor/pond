if ENV["CDN_HOST"].present?
  Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy
else
  Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_redirect
end
