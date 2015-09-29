# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
end

students = [
  ["jane", "doe"],
  ["joe", "smith"],
  ["kareem", "abdul-jabaar"],
  ["dikembe", "muotumbo"]
]

students.each do |student|
  student = User.sign_up(student[0], student[1])
  student.save
  membership = student.memberships.create(group_id: WDI.id, is_admin?: false)
  wdi[:students][student.username] = membership
end

wdi[:instructors]["robin"].authored_observations.create!(observee_id: wdi[:students]["jane"].id, body: "Jane is cool. A+")

day_one = WDI.events.create(date: DateTime.new(2015, 10, 16))
day_two = WDI.events.create(date: DateTime.new(2015, 10, 17))

assignment = WDI.assignments.create(due_date: DateTime.new(2015, 10, 16), category: "homework", title: "Pixart")
assignment_two = WDI.assignments.create(due_date: DateTime.new(2015, 10, 17), category: "project", title: "Project 1")
