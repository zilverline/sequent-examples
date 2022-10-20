
class Database
  class << self
    # def database_config(env = ENV['RACK_ENV'])
    #   @config ||= YAML.safe_load(ERB.new(File.read('db/database.yml')).result, aliases: true)[env]
    # end

    def establish_connection(env = ENV['RACK_ENV'])
      Sequent::Support::Database.connect!(env)
      # config = database_config(env)
      # yield(config) if block_given?
      # ActiveRecord::Base.configurations[env.to_s] = config.stringify_keys
      # ActiveRecord::Base.establish_connection config
    end
  end
end
