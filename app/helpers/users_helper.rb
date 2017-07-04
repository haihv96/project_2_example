module UsersHelper
  def avatar_tag user, options = {}
    user_avatar = user.avatar
    if user_avatar.present? && user_avatar.file.exists?
      avatar_url = user_avatar
    else
      avatar_url = image_path(Settings.user.avatar.default)
    end
    options[:src] = avatar_url
    tag "img", options
  end
end
