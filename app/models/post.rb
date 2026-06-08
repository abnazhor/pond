class Post < ApplicationRecord
  belongs_to :collection, optional: true
  belongs_to :url_cache, optional: true

  validates_url :url, presence: true, schemes: [ :http, :https ]
end
