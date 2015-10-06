Assignment.destroy_all
Attendance.destroy_all
Event.destroy_all
Group.destroy_all
Membership.destroy_all
Observation.destroy_all
Submission.destroy_all
User.destroy_all

groups = {
  "ga": {
    "wdi": {
      "dc": {
        "wdidc5": {
          "classroom1": {
          },
          "classroom2": {
          }
        },
        "wdidc6": {
          "classroom1": {
          },
          "classroom2": {
          }
        },
        "wdidc7": {
          "classroom1": {
          },
          "classroom3": {
          },
          "classroom4": {
          }
        }
      }
    }
  }
}

instructors6 = [
  ["robin", "thomas"],
  ["andy", "kim"],
  ["adam", "bray"],
  ["matt", "scilipoti"],
  ["jesse", "shawl"],
  ["adrian", "maseda"]
]

instructors7 = [
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

students6 = [
  ["jane", "doe"],
  ["joe", "smith"],
  ["kareem", "abdul-jabaar"],
  ["dikembe", "muotumbo"]
]

students7 = [
  ["harry", "potter"],
  ["hermione", "granger"],
  ["ron", "weasley"]
]


Group.bulk_create(groups)
wdi6 = Group.named("wdidc6")
wdi7 = Group.named("wdidc7")

Membership.bulk_create(instructors6, wdi6.id, true)
Membership.bulk_create(students6, wdi6.id, false)

Membership.bulk_create(instructors7, wdi7.id, true)
Membership.bulk_create(students7, wdi7.id, false)

robin = User.named("robin")
jesse = User.named("jesse")
andy = User.named("andy")
jane = User.named("jane")

robin.role("wdidc6", "admin").observe("jane", "Jane is cool. A+", 2)
robin.role("wdidc6", "admin").observe("jane", "Jane is no longer cool", 0)
jesse.role("wdidc6", "admin").observe("jane", "Jane smells", 1)
andy.role("wdidc6", "admin").observe("jane", "Basically wrote Facebook for final project", 2)
robin.role("wdidc6", "admin").observe("joe", "Joe is lame. F-", 0)
jesse.role("wdidc6", "admin").observe("joe", "Joe bribed me with donuts", 1)
robin.role("wdidc6", "admin").observe("dikembe", "Dikembe has a cool name. C-", 1)

wdi6.events.create(date: DateTime.new(2015, 10, 16))
wdi6.events.create(date: DateTime.new(2015, 10, 17))
wdi7.events.create(date: DateTime.new(2015, 10, 16))
wdi7.events.create(date: DateTime.new(2015, 10, 17))

assignment_one = wdi6.assignments.create(due_date: DateTime.new(2015, 10, 16), category: "homework", title: "Pixart", repo_url: "www.github.com")
assignment_two = wdi6.assignments.create(due_date: DateTime.new(2015, 10, 17), category: "project", title: "Project 1", repo_url: "www.github.com")

jane.role("wdidc6", "student").submitted_submissions.each_with_index do |submission, i|
  if i % 2 == 0
    submission.status = "complete"
    submission.save
  end
end

jane.role("wdidc6", "student").attendances.each_with_index do |attendance, i|
  if i % 2 == 0
    attendance.status = "absent"
  else
    attendance.status = "present"
  end
  attendance.save
end
