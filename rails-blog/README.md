# Rails & Sequent

This is an example project on how to add Sequent to an existing Rails application.
This Rails application is weblog application created from the 
[Rails Getting Started Guide](https://guides.rubyonrails.org/getting_started.html) 
(up to [deleting an Article](https://guides.rubyonrails.org/getting_started.html#deleting-an-article)).

On top of this, Sequent is added. The example is modified so that Articles in the application are synonymous for 
PostsRecords. This doesn't really makes much sense but it just a demonstration on how to add Sequent to a Rails application.

See [Rails & Sequent](https://sequent.io/docs/rails-sequent.html) for the full step-by-step guide.

## Setup your environment

```bash
git clone https://github.com/zilverline/sequent-examples.git
cd rails-blog
rbenv install
gem install bundler
bundle install
```

## Initialize the app

```bash
rails db:create
rails migrate_public_schema
bundle exec rake sequent:db:create_event_store
bundle exec rake sequent:db:create_view_schema
bundle exec rake sequent:migrate:online
bundle exec rake sequent:migrate:offline
rails s
```

Open [http://localhost:3000/articles](http://localhost:3000/articles)
