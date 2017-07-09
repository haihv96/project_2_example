class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    alias_action :update, :destroy, to: :modify

    if user
      user_id = user.id
      can :manage, :all if user.try :admin?
      can :read, :all
      can :create, Post
      can :modify, Post, user_id: user_id
      comment_permission user
    else
      cannot [:create, :modify], :all
    end
  end

  private

  def comment_permission user
    user_id = user.id
    can :create, Comment do |build_comment|
      post_author = build_comment.post.user
      user.following?(post_author) || user.is?(post_author)
    end
    can :update, Comment, user_id: user_id
    can :destroy, Comment do |comment|
      user.is?(comment.user) || user.is?(comment.post.user)
    end
  end
end
