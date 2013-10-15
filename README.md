# taskmapper-fogbugz

This is the [TaskMapper][] adapter for interaction with [Fogbugz][]

## Usage

Initialize the taskmapper-fogbugz instance using your email, password, and
Fogbugz URI:

```ruby
fogbugz = TaskMapper.new(
  :fogbugz,
  :email => "YOUR_EMAIL",
  :password => "YOUR_PASSWORD",
  :uri => "https://YOUR_SUBDOMAIN.fogbugz.com",
)
```

## Finding Projects

You can find your own projects by using:

```ruby
projects = fogbugz.projects
projects = fogbugz.projects ["project_id", "another_project_id"]
project = fogbugz.projects.find :first, "project_id"
projects = fogbugz.projects.find :all, ["project_id", "another_project_id"]
```

## Finding Tickets

```ruby
tickets = project.tickets # All open tickets
tickets = project.tickets :all, :status => 'closed' # all closed tickets
ticket = project.ticket 981234
```

## Opening A Ticket

```ruby
ticket = project.ticket!(
  :description => "Content of the new ticket."
)
```

## Updating Tickets

```ruby
ticket.description = "New description"
ticket.save
```

## Dependencies

- rubygems
- [taskmapper][]
- [ruby-fogbugz][]

## Contributing

The main way you can contribute is with some code! Here's how:

- Fork `taskmapper-fogbugz`
- Create a topic branch: git checkout -b my_awesome_feature
- Push to your branch - git push origin my_awesome_feature
- Create a Pull Request from your branch
- That's it!

We use RSpec for testing. Please include tests with your pull request. A simple
`bundle exec rake` will run the suite. Also, please try to TomDoc your methods,
it makes it easier to see what the code does and makes it easier for future
contributors to get started.

(c) 2013 The Hybrid Group

[taskmapper]: http://ticketrb.com
[fogbugz]: http://www.fogcreek.com/fogbugz/
[ruby-fogbugz]: https://github.com/firmafon/ruby-fogbugz
