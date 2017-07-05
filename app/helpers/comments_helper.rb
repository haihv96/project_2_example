module CommentsHelper
  def remember_enter_to_comment
    cookies.permanent[:enter_to_comment] = true
  end

  def forget_enter_to_comment
    cookies.delete :enter_to_comment
  end

  def enter_to_comment?
    return true if cookies[:enter_to_comment].present?
  end
end
