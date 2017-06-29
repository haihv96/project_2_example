class User < ApplicationRecord
  enum role: [:user, :admin]
  enum gender: [:female, :male, :other]

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

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
