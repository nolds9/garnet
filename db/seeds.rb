# ActiveRecord::Base.logger = Logger.new(STDOUT)

Assignment.destroy_all
Attendance.destroy_all
Event.destroy_all
Group.destroy_all
Membership.destroy_all
Observation.destroy_all
Submission.destroy_all
User.destroy_all

ga_groups = {
  "wdi": {
    "dc": {
      "5": {
        "rm1": {
        },
        "rm2": {
        }
      },
      "6": {
        "rm1": {
        },
        "rm2": {
        }
      },
      "7": {
        "rm4": {
        },
        "rm5": {
        },
        "rm6": {
        }
      }
    }
  }
}

instructors6 = [
  ["Robin", "Thomas"],
  ["Andy", "Kim"],
  ["Adam", "Bray"],
  ["Matt", "Scilipoti"],
  ["Jesse", "Shawl"],
  ["Adrian", "Maseda"]
]

instructors7 = [
  ["Robin", "Thomas"],
  ["Andy", "Kim"],
  ["Nick", "Olds"],
  ["Erica", "Irving"],
  ["Adam", "bray"],
  ["Matt", "scilipoti"],
  ["Jesse", "shawl"],
  ["John", "master"],
  ["Adrian", "maseda"]
]

students6 = [
  ["Jane", "Doe"],
  ["Joe", "Smith"],
  ["Kareem", "abdul-jabaar"],
  ["Dikembe", "muotumbo"]
]

students7 = [
  ["harry", "Potter"],
  ["Germione", "Granger"],
  ["Ron", "weasley"]
]

ga = Group.create(title: "ga")
ga.create_descendants(ga_groups, :title)

Group.at_path("ga_wdi_dc_6").bulk_create_memberships(instructors6, true)
Group.at_path("ga_wdi_dc_6_rm1").bulk_create_memberships(students6, false)
Group.at_path("ga_wdi_dc_7").bulk_create_memberships(instructors7, true)
Group.at_path("ga_wdi_dc_7").bulk_create_memberships(students7, false)

robin = User.named("robin")
jesse = User.named("jesse")
andy = User.named("andy")
jane = User.named("jane")
joe = User.named("joe")
dikembe = User.named("dikembe")

jane.was_observed("ga_wdi_dc_6", "robin", "Jane is cool.", 2)
jane.was_observed("ga_wdi_dc_6_rm1", "robin", "Jane is no longer cool.", 0)
jane.was_observed("ga_wdi_dc_6", "jesse", "Jane smells.", 1)
jane.was_observed("ga_wdi_dc_6_rm1", "andy", "Re-wrote Facebook", 2)

joe.was_observed("ga_wdi_dc_6", "robin", "Joe is lame", 0)
joe.was_observed("ga_wdi_dc_6_rm1", "jesse", "Joe bought me donuts", 1)

dikembe.was_observed("ga_wdi_dc_6", "robin", "Cool name", 1)

Group.at_path("ga_wdi_dc_6").events.create(date: DateTime.new(2015, 10, 16), required: true)
Group.at_path("ga_wdi_dc_6").events.create(date: DateTime.new(2015, 10, 17), required: true)
Group.at_path("ga_wdi_dc_7").events.create(date: DateTime.new(2015, 10, 16), required: true)
Group.at_path("ga_wdi_dc_7").events.create(date: DateTime.new(2015, 10, 17), required: true)

Group.at_path("ga_wdi_dc_6").assignments.create(due_date: DateTime.new(2015, 10, 16), category: "homework", title: "Pixart", repo_url: "www.github.com", required: true)
Group.at_path("ga_wdi_dc_6").assignments.create(due_date: DateTime.new(2015, 10, 17), category: "project", title: "Project 1", repo_url: "www.github.com", required: true)
Group.at_path("ga_wdi_dc_6_rm1").assignments.create(due_date: DateTime.new(2015, 10, 15), category: "homework", title: "Some homework", required: true)
Group.at_path("ga_wdi_dc_6_rm2").assignments.create(due_date: DateTime.new(2015, 10, 14), category: "homework", title: "HW for Cookies", required: true)

jane.submissions.each do |submission|
  submission.update(status: rand(0..2))
end
