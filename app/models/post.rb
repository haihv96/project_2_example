class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: {maximum: 255}
  validates :context, presence: true

  scope :feed_by_user, ->(following_ids, user_id) do
    where("user_id in (#{following_ids.join(",")}) OR user_id = #{user_id}")
      .order(created_at: :desc)
  end

  scope :linetime, -> {order created_at: :desc}

  def comments_timeline
    Comment.timeline id
  end

  def load_more_comments id_comment_continue, number
    Comment.load_comments id_comment_continue, number, id
  end

  def load_first_comments
    comments.order_time.limit 5
  end

  def count_first_comment
    comments.order_time.limit(6).count
  end

  def rest_comments id_comment_continue
    Comment.load_comments id_comment_continue, nil, id
  end
end
