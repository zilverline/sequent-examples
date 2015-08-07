# Example application for the [sequent](https://github.com/zilverline/sequent) gem

This example application shows an implementation of the sequent gem. It uses a postgres database
as event store and view model store.

## Getting started

```sh
git clone https://github.com/zilverline/sequent-examples
cd sequent-examples
bundle install
rake db:create # creates the sequent database
rake sequent:upgrade
rackup -p 4567
```

## Rebuilding the events
Use `rake sequent:rebuild` to replay all events.

See `db/view_model` for an example on replaying the events in order to rebuild the view model.


Browse to [http://localhost:4567](http://localhost:4567)
