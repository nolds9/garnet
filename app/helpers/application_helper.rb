module ApplicationHelper
  def repo_name url
    return url[(url.rindex("/") + 1)..-1] if url.include? "/"
  end

  def avatar user
    if user.image_url
      "<img class='avatar' src='#{user.image_url}' alt='#{user.username}' title='#{user.username}' />".html_safe
    end
  end
end
