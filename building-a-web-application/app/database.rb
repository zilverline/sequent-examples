require 'sequent'

class Database
  class << self
    def establish_connection(env = ENV['SEQUENT_ENV'])
      Sequent::Support::Database.connect!(env)
    end
  end
end
