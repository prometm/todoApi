# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, Project, user_id: user.id
    can %i[manage position complete], Task, project: { user_id: user.id }
  end
end
