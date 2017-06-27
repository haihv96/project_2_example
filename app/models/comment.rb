class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true, uniqueness: {case_sensitive: false}
  validates :post_id, presence: true, numericality: {only_integer: true}
  validates :user_id, presence: true, numericality: {only_integer: true}
end
