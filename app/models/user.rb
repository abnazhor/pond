class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :auth_codes, dependent: :destroy

  has_many :follows, foreign_key: :actor_id, dependent: :destroy
  has_many :followers, through: :follows, source: :target, source_type: "User"

  after_create :create_inbox_collection

  def self.find_by_username!(username)
    find_by!(username: username.gsub("@", ""))
  end

  def to_param
    "@#{username}"
  end

  def to_s
    "@#{username}"
  end

  def following?(target)
    Follow.where(actor: self, target: target).exists?
  end

  private

  def create_inbox_collection
    collections.create!(inbox: true, name: "Inbox", private: true)
  end
end
