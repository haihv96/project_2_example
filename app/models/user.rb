class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token

  enum gender: [:female, :male, :other]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: :Relationship,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: :Relationship,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :full_name, presence: true,
    length: {maximum: Settings.user.max_length_name}
  validates :email, presence: true,
    length: {maximum: Settings.user.max_length_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, allow_nil: true,
    length: {maximum: Settings.user.max_length_name}

  before_save :downcase_email

  scope :order_id, -> {order id: :ASC}

  scope :top_followers, -> {order id: :desc}

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated? attribute, token
    digest = self.send "#{attribute}_digest"
    return false unless digest.present?
    BCrypt::Password.new(digest).is_password? token
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def forget
    update_attributes remember_digest: nil
  end

  def follow other_user
    following << other_user if other_user.present? &&
      !following?(other_user)
  end

  def unfollow other_user
    following.delete other_user if other_user.present? &&
      following?(other_user)
  end

  def following? other_user
    following.include? other_user
  end

  def feed
    following.present? ? Post.feed_by_user(following.ids, id) : self.posts
  end

  def is_author? post
    self == post.user
  end

  def can_comment? post
    following?(post.try :user) || is_author?(post)
  end

  def is_commentator? comment
    self == comment.user
  end

  def can_delete? comment
    (is_commentator? comment) || (self == comment.post.user)
  end

  private

  def downcase_email
    email.downcase!
  end
end
