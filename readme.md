# Garnet

## Local Setup

```
$ git clone https://github.com/ga-dc/garnet
$ cd garnet
$ bundle
$ rake db:create
$ rake db:migrate
$ rake db:seed
$ rails s
```

## current_user

It exists. See the application controller and helper.

## Github Authentication

### Setup

```
bundle exec figaro install
```

[Register a Github application](https://github.com/settings/applications) and update `config/application.yml` to look like this:

```
gh_client_id: "12345"
gh_client_secret: "67890"
gh_redirect_url: "http://localhost:3000/github/authenticate"
```

### Github model

The Github model has an API method. To use it:

```rb
# Gets the current organization's repos
request = Github.new(ENV).api.repos

# Gets the current user's repos
request = Github.new(ENV, session[:access_token]).api.repos
```

It's built on the Octokit gem. For more information [see the Octokit docs](https://github.com/octokit/octokit.rb).

## Methods of note

- `@user.role`: returns a specific membership
- `Membership.in_role`: returns a specific membership
- `Membership.bulkCreate`
- `Group.bulkCreate`: creates a tree of groups (nested groups)
- `@group.all_subgroups`: returns a single-level array of all subgroups nested under this group
- `@group.subgroup_tree`: returns a nested hash of all subgroups nested under this group

## User stories

Should be able to...

### Users with an admin membership to a group
("The group" refers to the group and all its sub-groups)
- Assignments
  - Create an assignment for the group
    - Automatically create incomplete submissions for all non-admin members of the group
  - Grade (update) a submission for the group
- Groups
  - Create a sub-group within the group
  - Add admin memberships to the group
  - Add non-admin memberships to the group
- Observations
  - Create an observation for a non-admin member of the group

### All users
- User info
  - Change their password, username, and name
  - Authorize their account for Github API access
- Submissions
  - Complete a submission for an assignment (via update)
  - See submissions that they have completed
  - See submissions that have been assigned to (created for) them
- Attendance
  - Mark that they have attended an event
  - See events they have attended
  - See events at which they are expected to attend

### Student
