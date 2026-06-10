class Post < ApplicationRecord
  has_many :pins, as: :pinable, dependent: :destroy
  belongs_to :collection, optional: true
  belongs_to :url_cache, optional: true

  validates_url :url, presence: true, schemes: [ :http, :https ]

  def refresh_pins_cards
    pins.find_each do |pin|
      broadcast_replace_later_to(pin, :card, targets: ".meta_pin_#{pin.id}", html: Components::Pins::Pin::Meta.new(pin: pin).call)
      broadcast_replace_later_to(pin, :card, targets: ".thumb_pin_#{pin.id}", html: Components::Pins::Pin::Thumb.new(pin: pin).call)
    end
  end
end
