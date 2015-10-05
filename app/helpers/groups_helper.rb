module GroupsHelper

  def subgroup_tree_html(group)
    output = "<li><a href='/groups/#{group.id}'>#{group.title}</a><ul>"
    group.subgroups.each do |subgroup|
      output += subgroup_tree_html(subgroup)
    end
    output += "</ul></li>"
    return output.html_safe
  end

  def breadcrumbs(group)
    output = ""
    group.all_parents.each do |group|
      output += "&lt; <a href='/groups/#{group.id}'>#{group.title}</a>"
    end
    return output.html_safe
  end

end
