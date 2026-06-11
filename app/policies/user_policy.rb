class UserPolicy < ApplicationPolicy
  def update?
    user.present? && record.id == user.id
  end

  def add_collection?
    update?
  end

  def follow?
    user != record && user.present?
  end

  def unfollow?
    user != record && user.present?
  end
end
