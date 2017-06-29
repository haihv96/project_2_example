class PostTag < ApplicationRecord
  belongs_to :tag
  belongs_to :post

  validates :tag, presence: true
  validates :post, presence: true
end
