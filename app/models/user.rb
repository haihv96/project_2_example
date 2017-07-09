class User < ApplicationRecord
  VALID_PHONE_REGEX = /\A(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*\z/

  enum role: [:member, :admin]
  enum gender: [:female, :male, :other]

  mount_uploader :avatar, AvatarUploader
  crop_uploaded :avatar

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passive_relationships

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, presence: true,
    length: {maximum: Settings.user.full_name.max_length}
  validates :phone, format: {with: VALID_PHONE_REGEX},
    length: {maximum: Settings.user.phone.max_length}, allow_blank: true
  validate :avatar_size

  before_save :downcase_email

  scope :order_manager, lambda {
    order "field(role," << User.roles.values.to_a.reverse.join(",") << ")"
  }

  def feed
    if following.present?
      Post.feed_by_user following.ids, id
    else
      posts.time_line
    end
  end

  def is? other_user
    self == other_user
  end

  def follow other_user
    return if following?(other_user) || self.is?(other_user)
    following << other_user
  end

  def unfollow other_user
    return unless other_user.present? || following?(other_user)
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private

  def downcase_email
    email.downcase!
  end

  def avatar_size
    errors.add(:avatar, I18n.t("user.avatar.warning")) if
      avatar.size > (Settings.user.avatar.max_size).megabytes
  end
end
