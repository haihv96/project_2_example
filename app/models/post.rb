class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  validates :user, presence: true
  validates :title, presence: true,
    length: {maximum: Settings.post.title.max_length}
  validates :content, presence: true

  scope :time_line, ->{order(created_at: :desc)}

  scope :feed_by_user, lambda {|following_ids, user_id|
    where("user_id in (#{following_ids.join(',')}) OR user_id = #{user_id}")
      .time_line
  }

  def paginate_comments current_page
    Comment.paginate id, current_page, Settings.comments.per_page
  end
end
