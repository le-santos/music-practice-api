class MusicPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  def destroy?
    record.user_id == user.id
  end
end
