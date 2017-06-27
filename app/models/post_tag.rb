class PostTag < ApplicationRecord
  belongs_to :tag
  belongs_to :post

  validates :tag_id, numericality: {only_integer: true}
  validates :post_id, numericality: {only_integer: true}
end
