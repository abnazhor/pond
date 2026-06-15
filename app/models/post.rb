class Post < ApplicationRecord
  has_many :pins, as: :pinable, dependent: :destroy
  has_many :collections, through: :pins
  belongs_to :collection, optional: true
  belongs_to :user

  after_commit :refresh_caches

  def refresh_pins_cards
    pins.find_each do |pin|
      broadcast_replace_later_to(pin, :card, targets: ".meta_pin_#{pin.id}", html: Components::Pins::Pin::Meta.new(pin: pin).call)
      broadcast_replace_later_to(pin, :card, targets: ".thumb_pin_#{pin.id}", html: Components::Pins::Pin::Thumb.new(pin: pin).call)
    end
  end

  private

  # @todo probably move that to a job?
  def refresh_caches
    pins.touch_all
    collections.touch_all
  end
end
