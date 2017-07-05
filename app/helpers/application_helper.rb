module ApplicationHelper
  def time_status object
    created_at = object.created_at
    updated_at = object.updated_at
    ago = t("helpers.ago")
    if created_at == updated_at
      time_ago_in_words(created_at) << " " << ago
    else
      t("helpers.update") << time_ago_in_words(updated_at) << " " << ago
    end
  end
end
