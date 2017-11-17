# Example application for the [sequent](https://github.com/zilverline/sequent) gem

This example application shows an implementation of the sequent gem. It uses a postgres database
as event store and view model store.

## Getting started

```sh
git clone https://github.com/zilverline/sequent-examples
cd sequent-examples/sinatra
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake view_schema:build
bundle exec rackup -p 4567
```

Browse to [http://localhost:4567](http://localhost:4567)
