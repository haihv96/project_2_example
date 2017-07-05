class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true
  validates :post, presence: true
  validates :user, presence: true

  scope :paginate, lambda {|post_id, current_page, per_page|
    where(post_id: post_id).order(created_at: :desc)
      .page(current_page).per per_page
  }
end
