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
