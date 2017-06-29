class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :user, presence: true
  validates :title, presence: true,
    length: {maximum: Settings.post.title.max_length}
  validates :content, presence: true
end
