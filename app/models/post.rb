class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :user_id, presence: true, numericality: {only_integer: true}
  validates :title, presence: true,
    length: {maximum: Settings.post.title.max_length}
  validates :content, presence: true
end
