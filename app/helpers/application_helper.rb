module ApplicationHelper
  def repo_name url
    return url[(url.rindex("/") + 1)..-1] if url.include? "/"
  end

  def breadcrumbs(group, user = nil)
    output = [(link_to group.title, group_path(group))]
    group.ancestors.each do |group|
      output.unshift((link_to group.title, group_path(group)))
    end
    if user
      output.push((link_to user.username, profile_path(user)))
    end
    return output.join("<").html_safe
  end

  def subgroup_tree_html(group)
    output = "<li><a href='/groups/#{group.id}'>#{group.title}</a><ul>"
    group.children.each do |subgroup|
      output += subgroup_tree_html(subgroup)
    end
    output += "</ul></li>"
    return output.html_safe
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

  def markdown(text)
    markdown_to_html = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown_to_html.render(text).html_safe
  end

  def profile_path user
    "/profile?user=#{user.username}"
  end

end
