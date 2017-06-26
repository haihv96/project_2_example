class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :context, presence: true

  scope :order_time, -> {order(created_at: :desc)}
  scope :last_id,->{ids.last}
  scope :timeline, ->(post_id) do
    where("post_id = ?", post_id).order_time
  end

  scope :load_comments, ->(id_comment_continue, number, post_id) do
    if id_comment_continue.present?
      where("post_id = #{post_id} and id < #{id_comment_continue}").limit(number)
        .order_time
    end
  end
end
