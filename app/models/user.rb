class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  enum role: [:user, :admin]
  enum gender: [:female, :male, :other]

  has_many :posts
  has_many :comments
  has_many :active_relationships, class_name: :Relationship,
    foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: :Relationship,
    foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passive_relationships

  validates :full_name, presence: true,
    length: {maximum: Settings.user.full_name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, allow_nil: true,
    length: {maximum: Settings.user.password.max_length}

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
