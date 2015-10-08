module UsersHelper

  def profile_editable? user
    (!current_user || (user.id == current_user.id && !user.github_id ))
  end

  def profile_fields_conditionally_editable_for user, fields
    is_disabled = !profile_editable?(user)
    output = []
    fields.each do |label, placeholder|
      output.push(text_field_tag(label, user.send(label), placeholder: placeholder, disabled: is_disabled))
    end
    output.join("\n").html_safe
  end

end
