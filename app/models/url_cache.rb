class UrlCache < ApplicationRecord
  # include UrlCacheThumbUploader::Attachment(:thumb)
  has_one_attached :thumb do |attachable|
    attachable.variant :square_300, resize_to_fill: [ 300, 300 ], preprocessed: true
  end

  def fresh?
    refreshed_at.present? && refreshed_at > 1.hour.ago
  end
end
