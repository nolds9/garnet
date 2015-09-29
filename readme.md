# Garnet

## Local Setup

    $ git clone https://github.com/ga-dc/garnet
    $ cd garnet
    $ bundle
    $ rake db:create
    $ rake db:migrate
    $ rake db:seed
    $ rails s

## User stories

Should be able to...

### Users with an admin membership to a group
("The group" refers to the group and all its sub-groups)

- Create an assignment for the group
  - Automatically create incomplete submissions for all non-admin members of the group
- Grade (update) a submission for the group

- Create a sub-group within the group
- Add admin memberships to the group
- Add non-admin memberships to the group

- Create an observation for a non-admin member of the group

### All users
- Change their password, username, and name
- Authorize their account for Github API access

- Complete a submission for an assignment (via update)
- See submissions that they have completed
- See submissions that have been assigned to (created for) them

- Mark that they have attended an event
- See events they have attended
- See events at which they are expected to attend

### Student
