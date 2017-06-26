module ApplicationHelper
  def time_status object
    if object.created_at == object.updated_at
      "#{time_ago_in_words object.created_at} ago"
    else
      "Updated #{time_ago_in_words object.updated_at} ago"
    end
  end
end
