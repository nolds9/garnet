User.destroy_all
Group.destroy_all
Membership.destroy_all
Observation.destroy_all
Event.destroy_all
Assignment.destroy_all

WDI = Group.create(title: "WDI7")
wdi = {
  instructors: {},
  students: {}
}

WDI8 = Group.create(title: "WDI8")
wdi8 = {
  instructors: {},
  students: {}
}

instructors = [
  ["robin", "thomas"],
  ["andy", "kim"],
  ["nick", "olds"],
  ["erica", "irving"],
  ["adam", "bray"],
  ["matt", "scilipoti"],
  ["jesse", "shawl"],
  ["john", "master"],
  ["adrian", "maseda"]
]

instructors.each do |instructor|
  instructor = User.sign_up(instructor[0], instructor[1])
  instructor.save
  membership = instructor.memberships.create(group_id: WDI.id, is_admin?: true)
  wdi[:instructors][instructor.username] = membership
  membership8 = instructor.memberships.create(group_id: WDI8.id, is_admin?: true)
  wdi8[:instructors][instructor.username] = membership8
end

students = [
  ["jane", "doe"],
  ["joe", "smith"],
  ["kareem", "abdul-jabaar"],
  ["dikembe", "muotumbo"]
]

students.each do |student|
  student = User.sign_up(student[0], student[1])
  student.image_url = "http://placebear.com/200/200"
  student.save
  membership = student.memberships.create(group_id: WDI.id, is_admin?: false)
  wdi[:students][student.username] = membership
end

students8 = [
  ["big", "bird"],
  ["oscar", "grouch"],
  ["cookie", "monster"]
]

students8.each do |student|
  student = User.sign_up(student[0], student[1])
  student.save
  membership = student.memberships.create(group_id: WDI8.id, is_admin?: false)
  wdi8[:students][student.username] = membership
end

wdi[:instructors]["robin"].authored_observations.create!(observee_id: wdi[:students]["jane"].id, body: "Jane is cool. A+")

day_one = WDI.events.create(date: DateTime.new(2015, 10, 16))
day_two = WDI.events.create(date: DateTime.new(2015, 10, 17))

assignment = WDI.assignments.create(due_date: DateTime.new(2015, 10, 16), category: "homework", title: "Pixart", repo_url: "www.github.com")
assignment_two = WDI.assignments.create(due_date: DateTime.new(2015, 10, 17), category: "project", title: "Project 1", repo_url: "www.github.com")

# test student
jane = User.find_by(username: "jane")
jane = jane.memberships[0]
jane.submitted_submissions.each_with_index do |submission, i|
  if i % 2 == 0
    submission.status = "complete"
    submission.save
  end
end

jane.attendances.each_with_index do |attendance, i|
  if i % 2 == 0
    attendance.status = "absent"
  else
    attendance.status = "present"
  end
  attendance.save
end
