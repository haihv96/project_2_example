class PostTag < ApplicationRecord
  belongs_to :tag
  belongs_to :post, touch: true

  validates :tag, presence: true
  validates :post, presence: true
end
