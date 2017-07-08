class Post < ApplicationRecord
  attr_accessor :lists_tag

  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  validates :user, presence: true
  validates :title, presence: true,
    length: {maximum: Settings.post.title.max_length}
  validates :content, presence: true
  validates :lists_tag, presence: true, allow_blank: true

  scope :time_line, ->{order(created_at: :desc)}

  scope :feed_by_user, lambda {|following_ids, user_id|
    where("user_id in (#{following_ids.join(',')}) OR user_id = #{user_id}")
      .time_line
  }

  def paginate_comments current_page
    Comment.paginate id, current_page, Settings.comments.per_page
  end

  def tags_name
    return {} unless tags.present?
    tags.pluck :name
  end

  def create_transaction_post_tags
    ActiveRecord::Base.transaction do
      self.save!
      if validate_tags_length && build_tags
        return true
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid
    return false
  end

  def update_transaction_post_tags post_params
    ActiveRecord::Base.transaction do
      update_attributes post_params
      if validate_tags_length && update_tags
        return true
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid
    return false
  end

  def build_tags
    return true unless lists_tag.present?
    lists_tag.each do |tag|
      tags << Tag.find_or_create_by!(name: tag)
    end
  rescue ActiveRecord::RecordInvalid => exception
    errors[:lists_tag] << exception.message
  end

  def validate_tags_length
    max_tags = Settings.post.max_tags
    if lists_tag.present?
      if lists_tag.length > max_tags
        errors.add :lists_tag, I18n.t("posts.tags_length", number: max_tags)
        return false
      end
    end
    true
  end

  def update_tags
    return true unless lists_tag.present?
    delete_tags_if_not_exists
    update_new_tags
  end

  def update_new_tags
    names = tags.pluck :name
    lists_tag.each do |tag|
      tags << Tag.find_or_create_by(name: tag) unless names.include? tag
    end
  end

  def delete_tags_if_not_exists
    tags.each do |current_tag|
      tags.delete current_tag unless lists_tag.include? current_tag.name
    end
  end
end
