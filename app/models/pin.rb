class Pin < ApplicationRecord
  belongs_to :pinable, polymorphic: true
  belongs_to :collection, counter_cache: true
  belongs_to :user

  delegated_type :pinable, types: %w[Post]

  accepts_nested_attributes_for :pinable

  scope :in_inbox, -> { where(collection_id: nil) }
  scope :newest_first, -> { order(created_at: :desc) }

  validates :collection_id, presence: true
  validate :unique_per_collection

  private

  def unique_per_collection
    if Pin.exists?(collection_id: collection_id, pinable_type: pinable_type, pinable_id: pinable_id)
      errors.add(:base, "This item is already pinned in the selected collection.")
    end
  end
end
