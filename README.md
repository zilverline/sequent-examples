# Example application for the [sequent](https://github.com/zilverline/sequent) gem

This example application shows an implementation of the sequent gem. It uses a postgres database
as event store and view model store.

## Getting started

    git clone https://github.com/zilverline/sequent-example
    cd sequent-example
    bundle install
    rake db:create # creates the sequent database
    rackup -p 4567
    
Browse to [http://localhost:4567](http://localhost:4567)
