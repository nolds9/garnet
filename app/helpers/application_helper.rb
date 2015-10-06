module ApplicationHelper
  def repo_name url
    return url[(url.rindex("/") + 1)..-1] if url.include? "/"
  end

  def avatar user
    if user.image_url
      "<img class='avatar' src='#{user.image_url}' alt='#{user.username}' title='#{user.username}' />".html_safe
    end
  end

  def color_of input
    return if !input
    if !(input.class < Numeric)
      input = input.average(:status) || 0
    end
    case input * 100
    when 0...50
      return "#fba"
    when 50...100
      return "#fda"
    when 100...150
      return "#dfa"
    when 150..200
      return "#afa"
    end
  end

  def percent_of collection, value
    divisor = collection.where(status: value).length
    return 1 if divisor <= 0
    (divisor.to_f / collection.length).round(2)
  end

end
