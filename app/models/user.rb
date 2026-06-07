class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :auth_codes, dependent: :destroy

  after_create :create_inbox_collection

  def to_param
    "@#{username}"
  end

  def to_s
    "@#{username}"
  end

  def self.find_by_username!(username)
    find_by!(username: username.gsub("@", ""))
  end

  private

  def create_inbox_collection
    collections.create!(inbox: true, name: "Inbox", private: true)
  end
end
