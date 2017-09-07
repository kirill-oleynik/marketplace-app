class UserPolicy < ApplicationPolicy
  def update?
    self_update?
  end

  def password?
    self_update?
  end

  private

  def self_update?
    user == record
  end
end
