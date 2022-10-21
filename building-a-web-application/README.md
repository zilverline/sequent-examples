# Blog example

This contains the blog app from the [Building a web application](https://www.sequent.io/docs/building-a-web-application.html) guide.

## Setup your environment

```bash
git clone https://github.com/zilverline/sequent-examples.git
cd building-a-web-application
rbenv install
gem install bundler
bundle install
```

## Initialize the app

To create the database and tables:

```
cd building-a-web-application
bundle exec rake sequent:db:create
bundle exec rake sequent:db:create_view_schema
bundle exec rake sequent:migrate:online
bundle exec rake sequent:migrate:offline
```

## Start the app

```
cd building-a-web-application
bundle exec rackup -p 4567
```

Open [localhost:4567](http://localhost:4567)

## Testing

To create the test database:

```
cd building-a-web-application
RACK_ENV=test bundle exec rake sequent:db:create
```

And running the spec:

```
RACK_ENV=test bundle exec rspec
```
