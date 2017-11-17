# Example Rails app for Sequent

## Getting started

```sh
git clone https://github.com/zilverline/sequent-examples
cd sequent-examples/rails
bundle install
bundle exec rake sequent:db:create
bundle exec rake sequent:db:migrate
bundle exec rake sequent:view_schema:build
bundle exec rails s
```

Open http://localhost:3000/invoice

## Points to consider when using with Rails

- The normal Rails migrations are not used for the event sourced part of the application
- Check `config/sequent_app.rb` and the `initializers/sequent.rb` on how to setup Sequent in Rails
- Form helper support is somewhat limitted since you typically bind to `Sequent::Core::Command` and these
    are not ActiveRecord objects but ActiveModel.
